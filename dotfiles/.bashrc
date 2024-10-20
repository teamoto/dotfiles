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
