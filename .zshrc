PROMPT=$'%{\e[31m%}%n%{\e[m%}@%{\e[32m%}%m%{\e[m%}:%l: %{\e[1;33m%}%~%{\e[m%}\n%# '
export EDITOR='vim'
export PATH=~/bin:~/utils/:${PATH}

bindkey -e
#bindkey "^G"
bindkey "^X^B" backward-word
bindkey "^X^F" forward-word
bindkey "^X^D" kill-word
bindkey "^R" history-incremental-search-backward
bindkey "^T" history-incremental-search-forward
zle -C _complete_files complete-word complete-files
complete-files () { compadd - $PREFIX* }
bindkey "^Xl" _complete_files

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

autoload -U compinit
compinit -u

#### history
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt auto_pushd
setopt noautoremoveslash
setopt append_history
setopt auto_param_slash
setopt magic_equal_subst

zstyle ':completion:*:default' menu select=1

alias c="cd"
alias b="bg"
alias c="cd"
alias g="grep"
alias h="history"
alias j="jobs"
alias k="kill -9"
alias ls="ls -F --color=auto"
alias l="ls -F --color=auto"
alias m="make"
alias p="python"
alias v="vim"

alias lv='lv -c'
alias ssh='ssh -Y'
alias vimps="vim -c \":PS | :wincmd o\""
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""
alias vimbin='vim -c ":BinEdit'
alias parallel='parallel --gnu'
alias Kill='kill -9'
alias javac='javac -J-Dfile.encoding=UTF-8'
alias java='java -Dfile.encoding=UTF-8'
alias -g L='2>&1 |less -R'
alias -g G='2>&1 |grep '
alias -g TL='2>&1 |tee log'
alias -g TLA='2>&1 |tee -a log'
alias -g TLH='2>&1 |tee ~/log'
alias C="source ~/.vimrc.cwd"
function myglobal() { global --color=always --result grep -g -o $1 -S $2 $argv[3,-1] }
alias gg="myglobal"
alias gu="global -uv"
function myfg() { fg %$1 }
alias f="myfg"
alias g="fgrep --color=always"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1"
alias gpom="git push origin master"

stty stop undef

if [ "`uname|grep CYGWIN`" != "" ]; then
    chcp.com 65001
    alias s="cygstart"
    alias tmux="rm -rfv /tmp/tmux* && tmux"
else
    alias s="source"
fi

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

#function precmd()
#{
#    echo -ne "\033k$(basename $(tty)|sed 's/^tty//'):$(pwd|tail -c 20)\033\\"
#}
