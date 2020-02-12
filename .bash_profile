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
# Prioritise using homebrew binaries over system
export PATH="/Library/TeX/texbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Powerline user config
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source /Users/cliffordphan/Library/Python/3.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh

