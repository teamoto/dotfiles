# Exit immediately if not run interactively.
[[ $- != *i* ]] && return

test -s ~/.alias && . ~/.alias || true

if command -v alacritty &> /dev/null; then
    export TERM="alacritty"
else
    export TERM="xterm-256color"
fi

test -s ~/.bash_completion/alacritty && source ~/.bash_completion/alacritty || true
# In case ".bash_completion" exists as a file, then I create a directory ".bash_completion.d" and move the file there.
# Thus added the following line.
test -s ~/.bash_completion.d/alacritty && source ~/.bash_completion.d/alacritty || true
test -s ~/.bash_prompt && source ~/.bash_prompt || true

# Bash features

## History settings
# ref 1 https://www.geeksforgeeks.org/histcontrol-command-in-linux-with-examples/
# ref 2 https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history
# ref 3 https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#index-PROMPT_005fCOMMAND
# Ignore duplicates and erase duplicates when importing the past history.
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend # Append to the history file, but don't overwrite it.
PROMPT_COMMAND="history -n; history -w; history -c; history -r; ${PROMPT_COMMAND}"

