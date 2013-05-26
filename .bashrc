alias lv='lv -c'
alias ssh='ssh -X -Y'
alias vimps='ps aux | vim -c "set filetype=ps" -'
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""

export PROMPT_COMMAND='echo -ne "\033k$(pwd|tail -c 30)\033\\"'
