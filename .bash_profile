# Extend .bashrc if exists
if [ -f $HOME/.bashrc ]
then
    source ~/.bashrc
fi

# Environment variables
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

# Powerline user config
which powerline-daemon > /dev/null
if [ $? -eq 0 ]
then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source $HOME/Library/Python/3.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
    echo "Powerline configured"
else
    echo "Missing powerline config"
fi
