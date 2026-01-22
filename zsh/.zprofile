# basic set up
export EDITOR=vim


# import alias
source ~/.zsh/.alias
source ~/.zsh/.tools

# nvm set up
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# iCal Buddy Set up - Calendar in Terminal
alias today='icalBuddy -f -npn -nc -sd -sed -iep "title,datetime,location" -ps "| - | @ |" -po "title, datetime" -df "%d %b %Y (%a)" -eed eventsToday'
alias now='icalBuddy -f -npn -nc -sd -sed -iep "title,datetime,location" -ps "| - | @ |" -po "title, datetime" -df "%d %b %Y (%a)" -eed eventsNow'
alias 5days='icalBuddy -f -npn -nc -sd -sed -iep "title,datetime,location" -ps "| - | @ |" -po "title, datetime" -df "%d %b %Y (%a)" -eed eventsToday+5'

# Read md file
rmd() {
	pandoc $1 | lynx -stdin
}

# Load version control info
autoload -Uz vcs_info
precmd() {vcs_info}

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(%b)'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%n@[%1d] ${vcs_info_msg_0_} > '
