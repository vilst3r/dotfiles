# Extend .bashrc if exists
if [ -f $HOME/.bashrc ]
then
    source ~/.bashrc
fi

# Environment variables
export TERM=xterm-256color
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=ExfxcxdxBxgxexbxaxcxdx

# History settings
export HISTFILESIZE=250
export HISTTIMEFORMAT='%F %T ' # Timestamp each bash call

# Use vim keybinds for bash input stream
set -o vi

# Aliases
alias python=python3
alias pip=pip3

# Use brew binary for ARM-based Mac machines
if [ "$(uname)" == "Darwin" ] && [ -d /opt/homebrew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if test $(which python); then
    export PATH=$PATH:$(python -m site --user-base)/bin
fi

# Powerline user config
if test $(which powerline-daemon); then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source $(python -m site --user-site)/powerline/bindings/bash/powerline.sh
    echo "Powerline configured"
else
    echo "Missing powerline config"
fi

# e.g of how to use 'ssh <host>' (as long are they registered in the ssh-agent)
# ssh github.com-personal
# ssh github.com
