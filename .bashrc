alias lv='lv -c'
alias ssh='ssh -X -Y'
alias vimps='ps aux | vim -c "set filetype=ps" -'
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""
alias parallel='parallel --gnu'
alias Kill='kill -9'
function myclewn() {
  \pyclewn -e vim --cargs "-S ~/misc/.pyclewn.vim" --args "--args $*"
}

export PROMPT_COMMAND='echo -ne "\033k$(pwd|tail -c 30)\033\\"'

bind '"\C-x\C-f": forward-word'
bind '"\C-x\C-b": backward-word'
bind '"\C-x\C-h": backward-kill-word'
bind '"\C-x\C-d": kill-word'
#bind '"\C-xf": complete-filename'
#bind '"\C-xc": complete-command'
#bind '"\C-xv": complete-variable'
bind '"\C-_": complete-filename'
bind '"\e[1;5n": complete-command'
bind '"\e[1;5l": complete-variable'
