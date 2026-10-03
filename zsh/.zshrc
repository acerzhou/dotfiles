# ═══════════════════════════════════════════════════════════
# ZSH Configuration
# ═══════════════════════════════════════════════════════════

# ---- Shell Options -----------------------------------------------
setopt AUTO_CD              # Auto cd to directory without typing cd
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt EXTENDED_GLOB        # Extended globbing
setopt HIST_IGNORE_DUPS     # Don't record duplicate commands
setopt HIST_IGNORE_SPACE    # Ignore commands starting with space
setopt HIST_VERIFY          # Show command before executing from history
setopt INC_APPEND_HISTORY   # Append to history immediately
setopt SHARE_HISTORY        # Share history between sessions
setopt CORRECT              # Suggest corrections for mistyped commands
setopt PROMPT_SUBST         # Enable command substitution in prompt

# ---- History Configuration ---------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ---- Key Bindings ------------------------------------------------
bindkey -e  # Emacs key bindings

# ---- Terminal Configuration --------------------------------------
export LANG="${LANG:-en_US.UTF-8}"

# ---- Editor Configuration ----------------------------------------
export EDITOR=vim
export VISUAL=vim
export PAGER=less

# ---- Colors for less ---------------------------------------------
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# ═══════════════════════════════════════════════════════════
# Version Control (Git) Prompt
# ═══════════════════════════════════════════════════════════

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f '
zstyle ':vcs_info:*' enable git

# ---- Custom Prompt -----------------------------------------------
PROMPT='%F{blue}%~%f ${vcs_info_msg_0_}%F{green}❯%f '
RPROMPT='%F{8}%*%f'

# ═══════════════════════════════════════════════════════════
# Development Tools Configuration
# ═══════════════════════════════════════════════════════════

# ---- Homebrew (macOS) --------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# ---- Node.js (nvm) -----------------------------------------------
export NVM_DIR="$HOME/.nvm"
for nvm_script in "$NVM_DIR/nvm.sh" /opt/homebrew/opt/nvm/nvm.sh /usr/local/opt/nvm/nvm.sh; do
    if [ -s "$nvm_script" ]; then
        source "$nvm_script"
        break
    fi
done
unset nvm_script

# ---- Java (jenv) -------------------------------------------------
if [ -d "$HOME/.jenv" ]; then
    export PATH="$HOME/.jenv/bin:$PATH"
    if command -v jenv >/dev/null 2>&1; then
        eval "$(jenv init -)"
    fi
fi

# ---- Python (pyenv) ----------------------------------------------
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# ---- Go ----------------------------------------------------------
if command -v go &> /dev/null; then
    export GOPATH="$(go env GOPATH)"
    export PATH="$PATH:$GOPATH/bin"
fi

# ---- Rust --------------------------------------------------------
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# ---- Flutter -----------------------------------------------------
if [ -d "$HOME/Development/flutter" ]; then
    export PATH="$HOME/Development/flutter/bin:$PATH"
fi

# ---- Android -----------------------------------------------------
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/emulator"
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

# ═══════════════════════════════════════════════════════════
# Tool Integration
# ═══════════════════════════════════════════════════════════

# ---- fzf (Fuzzy Finder) ------------------------------------------
if command -v fzf &> /dev/null; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# ---- autojump ----------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
    for autojump_script in /opt/homebrew/etc/profile.d/autojump.sh /usr/local/etc/profile.d/autojump.sh; do
        if [ -f "$autojump_script" ]; then
            source "$autojump_script"
            break
        fi
    done
    unset autojump_script
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    [ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh
fi

# ═══════════════════════════════════════════════════════════
# Load Custom Configuration
# ═══════════════════════════════════════════════════════════

# Load aliases
[ -f ~/.zsh/.alias ] && source ~/.zsh/.alias

# Load custom tools and functions
[ -f ~/.zsh/.tools ] && source ~/.zsh/.tools

# ═══════════════════════════════════════════════════════════
# Local Configuration
# ═══════════════════════════════════════════════════════════

# Load local configuration (not tracked in git)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ═══════════════════════════════════════════════════════════
# Custom PATH additions
# ═══════════════════════════════════════════════════════════

typeset -U path
path=("$HOME/.local/bin" "$HOME/bin" $path)
export PATH
