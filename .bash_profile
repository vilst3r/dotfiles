alias python=python3
alias pip=pip3
# Prioritise using homebrew binaries over system
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
set -o vi

# Powerline user config
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source /Users/cliffordphan/Library/Python/3.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
