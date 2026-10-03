"""Regression checks use temporary homes and never install real packages."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]


class ManagementTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-tests-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        self.env = dict(os.environ, HOME=str(self.home), PATH="/usr/bin:/bin",
                        OSTYPE="darwin", SHELL="/bin/zsh")

    def run_script(self, script, *args, stdin="", expected=0):
        result = subprocess.run(["/bin/bash", str(REPO / script), *args],
                                env=self.env, input=stdin, text=True,
                                capture_output=True, cwd=self.home)
        self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        return result.stdout

    def backups(self):
        return sorted((self.home / ".dotfiles-backups").glob("*"))

    def test_check_reports_all_missing_links(self):
        output = self.run_script("scripts/dotfiles/links.sh", "check", expected=1)
        self.assertIn("8 missing (total: 8)", output)
        self.assertIn(".gitignore_global", output)

    def test_links_are_idempotent_and_hammerspoon_is_separate(self):
        self.env["OSTYPE"] = "darwin"
        self.run_script("scripts/dotfiles/links.sh", "install")
        self.run_script("scripts/dotfiles/links.sh", "install")
        self.run_script("scripts/dotfiles/links.sh", "check")
        self.assertFalse((self.home / ".hammerspoon").exists())
        self.assertEqual(self.backups(), [])
        other = self.home / ".vimrc"
        other.unlink()
        other.symlink_to(self.home / "unmanaged")
        self.run_script("scripts/dotfiles/links.sh", "uninstall")
        self.assertTrue(other.is_symlink())
        self.assertFalse((self.home / ".zshrc").exists())

    def test_partial_installer_backup_restores_hidden_files(self):
        (self.home / ".zshrc").write_text("original shell")
        zsh = self.home / ".zsh"
        zsh.mkdir()
        (zsh / ".alias").write_text("original aliases")
        (zsh / "local").write_text("keep me")
        self.run_script("scripts/dotfiles/links.sh", "install")
        backup = self.backups()[0]
        self.run_script("scripts/dotfiles/backups.sh", "restore", backup.name, stdin="y\n")
        self.assertEqual((self.home / ".zshrc").read_text(), "original shell")
        self.assertEqual((zsh / ".alias").read_text(), "original aliases")
        self.assertEqual((zsh / "local").read_text(), "keep me")
        self.assertFalse((zsh / ".alias").is_symlink())

    def test_snapshots_copy_linked_contents_and_do_not_collide(self):
        self.run_script("scripts/dotfiles/links.sh", "install")
        self.run_script("scripts/dotfiles/backups.sh", "backup")
        self.run_script("scripts/dotfiles/backups.sh", "backup")
        self.assertEqual(len(self.backups()), 2)
        backup = self.backups()[0]
        self.assertFalse((backup / ".zshrc").is_symlink())
        self.assertEqual((backup / ".zshrc").read_text(), (REPO / "zsh/.zshrc").read_text())
        self.run_script("scripts/dotfiles/backups.sh", "restore", backup.name, stdin="y\n")
        self.assertFalse((self.home / ".zshrc").is_symlink())
        self.assertFalse((self.home / ".zsh/.alias").is_symlink())

    def test_restore_into_empty_home_and_invalid_names(self):
        backup = self.home / ".dotfiles-backups/20260101-000000"
        backup.mkdir(parents=True)
        (backup / ".vimrc").write_text("original vim")
        self.run_script("scripts/dotfiles/backups.sh", "restore", backup.name, stdin="y\n")
        self.assertEqual((self.home / ".vimrc").read_text(), "original vim")
        self.run_script("scripts/dotfiles/backups.sh", "restore", expected=1)
        self.run_script("scripts/dotfiles/backups.sh", "restore", "../outside", expected=1)

    def test_cleanup_keeps_newest_five_and_unrelated_directories(self):
        base = self.home / ".dotfiles-backups"
        for day in range(1, 8):
            (base / f"202601{day:02d}-000000").mkdir(parents=True)
        (base / "unrelated").mkdir()
        self.run_script("scripts/dotfiles/backups.sh", "cleanup")
        self.assertEqual([p.name for p in self.backups()],
                         [f"202601{day:02d}-000000" for day in range(3, 8)] + ["unrelated"])

    def test_empty_backup_operations(self):
        self.run_script("scripts/dotfiles/backups.sh", "list")
        self.run_script("scripts/dotfiles/backups.sh", "backup")
        self.run_script("scripts/dotfiles/backups.sh", "cleanup")

    def test_profiles_are_listed_and_can_be_previewed(self):
        output = self.run_script("install.sh", "profiles")
        for profile in ("default", "personal"):
            self.assertIn(profile, output)
        self.assertNotIn("work", output)
        self.assertNotIn("general", output)

        output = self.run_script("install.sh", "install", "--profile", "personal",
                                 "--dry-run")
        self.assertIn("Install profile: personal", output)
        self.assertIn('brew "zsh"', output)

    def test_unknown_and_unsafe_profiles_fail_before_installing(self):
        for profile in ("missing", "../default"):
            output = self.run_script("install.sh", "install", "--profile", profile,
                                     expected=1)
            self.assertIn("profile", output.lower())

    def test_personal_install_uses_default_and_additional_brewfiles(self):
        bins = self.home / "bin"
        bins.mkdir()
        log = self.home / "brew.log"
        brew = bins / "brew"
        brew.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$BREW_LOG"\n')
        brew.chmod(0o755)
        self.env.update(OSTYPE="darwin", PATH=f"{bins}:/usr/bin:/bin",
                        BREW_LOG=str(log))
        self.run_script("install.sh", "install", "--profile", "personal")
        calls = log.read_text()
        self.assertIn("bundle --file=" + str(REPO / "brew/Brewfile"), calls)
        self.assertIn("bundle --file=" + str(REPO / "profiles/personal/Brewfile"), calls)

    def test_default_install_uses_only_the_canonical_brewfile(self):
        bins = self.home / "bin"
        bins.mkdir()
        log = self.home / "brew.log"
        brew = bins / "brew"
        brew.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$BREW_LOG"\n')
        brew.chmod(0o755)
        self.env.update(OSTYPE="darwin", PATH=f"{bins}:/usr/bin:/bin",
                        BREW_LOG=str(log))
        self.run_script("install.sh", "install")
        self.assertEqual(log.read_text().strip(),
                         "bundle --file=" + str(REPO / "brew/Brewfile"))

    def test_installer_rejects_unsupported_platforms(self):
        self.env["OSTYPE"] = "freebsd"
        output = self.run_script("install.sh", "install", "--dry-run", expected=1)
        self.assertIn("requires macOS", output)

    def test_config_does_not_install_packages(self):
        self.run_script("install.sh", "config", stdin="y\nn\n")
        self.assertTrue((self.home / ".zshrc").is_symlink())
        self.assertFalse((self.home / ".hammerspoon").exists())

    def test_config_rejects_package_profile_arguments(self):
        self.run_script("install.sh", "config", "--profile", "personal",
                        expected=1)
        self.assertFalse((self.home / ".zshrc").exists())

    @unittest.skipUnless(
        Path("/bin/zsh").is_file()
        and Path("/etc/shells").is_file()
        and "/bin/zsh" in Path("/etc/shells").read_text().splitlines(),
        "A registered /bin/zsh is unavailable",
    )
    def test_config_uses_registered_zsh_instead_of_path_precedence(self):
        bins = self.home / "bin"
        bins.mkdir()
        for name in ("zsh", "chsh"):
            command = bins / name
            command.write_text(
                '#!/bin/sh\nprintf "%s %s\\n" "$0" "$*" >> "$SHELL_LOG"\n'
            )
            command.chmod(0o755)
        log = self.home / "shell.log"
        self.env.update(
            OSTYPE="darwin",
            SHELL="/bin/bash",
            PATH=f"{bins}:/usr/bin:/bin",
            SHELL_LOG=str(log),
        )
        output = self.run_script("install.sh", "config", stdin="y\nn\n")
        self.assertIn("using /bin/zsh", output)
        self.assertIn("-s /bin/zsh", log.read_text())

    @unittest.skipIf(Path("/Applications/Hammerspoon.app").is_dir(),
                         "System Hammerspoon installation bypasses Homebrew")
    def test_hammerspoon_install_failure_preserves_configuration(self):
        self.env["OSTYPE"] = "darwin"
        bins = self.home / "bin"
        bins.mkdir()
        brew = bins / "brew"
        brew.write_text('#!/bin/sh\nif [ "$1" = list ]; then exit 1; fi\nexit 2\n')
        brew.chmod(0o755)
        self.env["PATH"] = f"{bins}:/usr/bin:/bin"
        config = self.home / ".hammerspoon"
        config.mkdir()
        (config / "init.lua").write_text("untouched")
        self.run_script("hammerspoon/install.sh", expected=2)
        self.assertEqual((config / "init.lua").read_text(), "untouched")
        self.assertEqual(self.backups(), [])

    @unittest.skipUnless(Path("/bin/zsh").exists(), "ZSH is unavailable")
    def test_shell_startup_has_no_conflicting_aliases(self):
        self.run_script("scripts/dotfiles/links.sh", "install")
        result = subprocess.run(["/bin/zsh", "-dfc",
                                 'OSTYPE=darwin; source "$HOME/.zprofile"; '
                                 'source "$HOME/.zshrc"; whence -w myip serve json fdir'],
                                env=self.env, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        for name in ("myip", "serve", "json", "fdir"):
            self.assertIn(f"{name}: function", result.stdout)

    @unittest.skipUnless(Path("/usr/bin/vim").exists(), "Vim is unavailable")
    def test_vim_starts_without_optional_plugins(self):
        result = subprocess.run(["/usr/bin/vim", "-i", "NONE", "-n", "-es", "-u",
                                 str(REPO / "vim/.vimrc"),
                                 "-c", "qa!"],
                                env=self.env, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertTrue((self.home / ".vim/undodir").is_dir())
        self.assertTrue((self.home / ".vim/swap").is_dir())

    def test_hammerspoon_backs_up_configuration_and_repeats_safely(self):
        self.env["OSTYPE"] = "darwin"
        (self.home / "Applications/Hammerspoon.app").mkdir(parents=True)
        config = self.home / ".hammerspoon"
        config.mkdir()
        (config / "init.lua").write_text("original config")
        self.run_script("hammerspoon/install.sh")
        self.assertEqual(config.resolve(), REPO / "hammerspoon")
        self.assertEqual((self.backups()[0] / ".hammerspoon/init.lua").read_text(), "original config")
        self.run_script("hammerspoon/install.sh")
        self.assertEqual(len(self.backups()), 1)
        self.env["OSTYPE"] = "freebsd"
        self.run_script("hammerspoon/install.sh", expected=1)


if __name__ == "__main__":
    unittest.main()
