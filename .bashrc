alias lv='lv -c'
alias ssh='ssh -X -Y'
alias vimps='ps aux | vim -c "set filetype=ps" -'
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""
alias parallel='parallel --gnu'
alias pyclewn='pyclewn -e vim --cargs "-S ~/misc/.pyclewn.vim" --args'

export PROMPT_COMMAND='echo -ne "\033k$(pwd|tail -c 30)\033\\"'

bind '"\C-x\C-f": forward-word'
bind '"\C-x\C-b": backward-word'
bind '"\C-x\C-h": backward-kill-word'
bind '"\C-x\C-d": kill-word'
bind '"\C-j": forward-search-history'
