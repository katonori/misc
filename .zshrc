PROMPT=$'%{\e[31m%}%n%{\e[m%}@%{\e[32m%}%m%{\e[m%}: %{\e[1;33m%}%~%{\e[m%}\n%# '

bindkey -e
#bindkey "^G"
bindkey "^X^B" backward-word
bindkey "^X^F" forward-word
bindkey "^X^D" kill-word
zle -C _complete_files complete-word complete-files
complete-files () { compadd - $PREFIX* }
bindkey "^Xl" _complete_files

autoload -U compinit
compinit -u

#### history
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history
setopt auto_pushd

zstyle ':completion:*:default' menu select=1

alias ls="ls -F --color=auto"
alias lv='lv -c'
alias ssh='ssh -Y'
alias vimps='ps aux | vim -c "set filetype=ps" -'
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""
alias vimbin='vim -c ":BinEdit'
alias parallel='parallel --gnu'
alias Kill='kill -9'

function gyclewn()
{
  \pyclewn -e vim --cargs "-S ~/misc/.pyclewn.vim" --args "--args $*"
}

#
# grep wrapper for vim
#
function mgrep()
{
    isRecursive=""
    isParallel=""
    isParaRecursive=""  # specify if execute grep parallely
    argArry=($@)
    lastArg=${argArry[$#]} # lastArg is treated as a directory name in parallel recursive mode.
    cmdArgs=""
    cmdPrefix=""
    excludeDirs="--exclude-dir={.svn,.git}"
    excludeFiles="--exclude=*.{o,bin,a,gz,swo,swp,out,db}"
    includeFiles=""
    for (( i = 1; i < ${#argArry[@]}; ++i ))
    do
        arg=$argArry[$i]
        case $arg in
            "-tc")
                includeFiles="--include=*.{c,cpp,h,hpp}"
                ;;
            "-tt")
                ;;
            "-to")
                excludeFiles=""
                ;;
            "-P")
                isParallel="on"
                ;;
            "-r")
                isRecursive="on"
                if [ "$isParallel" != "" ]; then
                    isParaRecursive="on"
                    cmdPrefix="find $lastArg -type f -print0 | xargs -0 -P8 -s 10000 "
                else
                    cmdArgs="$cmdArgs $arg"
                fi
                ;;
              *) cmdArgs="$cmdArgs $arg";;
        esac
    done
    cmdArgs="$excludeDirs $excludeFiles $includeFiles $cmdArgs"
    if [ "$isParaRecursive" = "" ]; then
        cmdArgs="$cmdArgs $lastArg"
    fi
    #echo "ARGS: $cmdArgs"
    #echo "Prefix: $cmdPrefix"

    # default cmd
    cmd="env LANG=C fgrep -nH $cmdArgs"
    if [ "$cmdPrefix" != "" ]; then
        cmd="$cmdPrefix $cmd"
    fi
    echo "Actual command: $cmd"
    bash -c "$cmd"
}

function rgrep()
{
    mgrep -r $*
}

function precmd()
{
    echo -ne "\033k$(pwd|tail -c 30)\033\\"
}
