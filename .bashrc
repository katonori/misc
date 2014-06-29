alias lv='lv -c'
alias ssh='ssh -Y'
alias vimps='ps aux | vim -c "set filetype=ps" -'
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""
alias vimbin='vim -c ":BinEdit'
alias parallel='parallel --gnu'
alias Kill='kill -9'
function myclewn() {
  \pyclewn -e vim --cargs "-S ~/misc/.pyclewn.vim" --args "--args $*"
}

#
# grep wrapper for vim
#
function mgrep() {
    isRecursive=""
    isParallel=""
    isParaRecursive=""  # specify if execute grep parallely
    argArry=($@)
    lastArg=${argArry[$#-1]}
    type=""
    cmdArgs=""
    cmdPrefix=""
    excludeDirs="--exclude-dir={.svn,.git}"
    excludeFiles="--exclude=*.{o,bin,a,gz,swo,swp,out,db}"
    for (( i = 0; i < ${#argArry[@]}-1; ++i ))
    do
        arg=${argArry[$i]}
        case $arg in
            "-tc") type="c";;
            "-tt") type="t";;
            "-to") type="o";;
            "-r")
                isRecursive="on"
                if [ "$isParallel" != "" ]; then
                    isParaRecursive="on"
                    cmdPrefix="find $lastArg -type f -print0 | xargs -0 -P1 -s 10000 "
                else
                    cmdArgs="$cmdArgs $arg"
                fi
                ;;
              *) cmdArgs="$cmdArgs $arg";;
        esac
    done
    if [ "$isParaRecursive" = "" ]; then
        cmdArgs="$cmdArgs $lastArg"
    fi
    if [ "$isRecursive" != "" ]; then
        cmdArgs="$excludeDirs $excludeFiles $cmdArgs"
    fi
    #echo "TYPE: $type"
    #echo "ARGS: $cmdArgs"
    #echo "Prefix: $cmdPrefix"

    # default cmd
    cmd="$cmdPrefix env LANG=C fgrep -nH $cmdArgs"
    case $type in
        "c") cmd="$cmdPrefix env LANG=C fgrep -nH --include=*.{c,cpp,h,hpp} $cmdArgs";;
        "t") ;; # default
        "o") cmd="$cmdPrefix grep $cmdArgs";;
          *) ;; # default
    esac
    echo $cmd
    bash -c "$cmd"
}

function rgrep() {
    mgrep -r $*
}

#export PROMPT_COMMAND='echo -ne "\033k$(pwd|tail -c 30)\033\\"'
#export LC_ALL=C

bind '"\C-x\C-f": forward-word'
bind '"\C-x\C-b": backward-word'
bind '"\C-x\C-h": backward-kill-word'
bind '"\C-x\C-d": kill-word'
#bind '"\C-xf": complete-filename'
#bind '"\C-xc": complete-command'
#bind '"\C-xv": complete-variable'
bind '"\C-_": complete-filename'
bind '"\C-^": complete-command'
#bind '"\C-\\": complete-variable'
bind '"\e[1;5n": complete-command'
bind '"\e[1;5l": complete-variable'

alias ls="ls -F --color=auto"
alias lv='lv -c'
alias ssh='ssh -Y'
alias vimps='ps aux | vim -c "set filetype=ps" -'
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""
alias vimbin='vim -c ":BinEdit'
alias parallel='parallel --gnu'
alias Kill='kill -9'
alias javac='javac -J-Dfile.encoding=UTF-8'
alias java='java -Dfile.encoding=UTF-8'

if [ `uname -o|grep -i cygwin` ]; then
    chcp.com 65001
fi
