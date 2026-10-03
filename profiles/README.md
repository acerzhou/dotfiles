# Profiles

The repository's root configuration and `brew/Brewfile` are the default. `personal/Brewfile` contains only additional personal packages; it is intentionally the profile's only file for now.

Omitting `PROFILE` installs the default packages. Run `make install PROFILE=personal` to install the default manifest followed by `personal/Brewfile`. Configuration does not vary by package profile.

Use `profiles/local/` for an untracked profile. It must contain a `Brewfile` so it passes the same validation as tracked profiles.
