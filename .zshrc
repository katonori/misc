PROMPT=$'%{\e[31m%}%n%{\e[m%}@%{\e[32m%}%m%{\e[m%}:${vcs_info_msg_0_}: %{\e[1;33m%}%~%{\e[m%}\n%# '
export EDITOR='vim'
export PATH=~/bin:~/utils/:${PATH}
export TERM=xterm-256color

source ~/.zplug/init.zsh

zplug "b4b4r07/enhancd"
zplug "mollifier/anyframe"

zplug load --verbose

#
# fzf
#
# fd - cd to selected directory
fd() {
  local dir
  dir=$(find -maxdepth 2 \
                  -o -type d -o -type l 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# fe - open folder by explorer
fe() {
  local dir
  dir=$(cdr -l 2> /dev/null | awk '{ print $2 }' | fzf +m) &&
  cygstart `eval echo $dir`
}

#
# cdr
#
# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

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
unsetopt hist_reduce_blanks
setopt auto_pushd
setopt noautoremoveslash
setopt append_history
setopt auto_param_slash
setopt magic_equal_subst

zstyle ':completion:*:default' menu select=1

alias r="anyframe-widget-cdr"
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
alias p2="python2"
alias p3="python3"
function v()
{
    LINE=`echo ${*} | sed 's/.\+:\([0-9]\+\)/\1/g'`
    ARGS=`echo ${*} | sed 's/:[0-9]\+//g'`
    if [ $LINE != "$*" ] ; then
        LINE="+${LINE}"
    else
        LINE=""
    fi
    #echo vim "$LINE" "$ARGS"
    vim $LINE $ARGS
}

alias lv='lv -c'
alias ssh='ssh -Y'
alias vimps="vim -c \":new | :wincmd o | :PsThisBuffer\""
alias vimgit="vim -c \":call fugitive#detect(expand('%:p')) | :Gstatus\""
alias vg="vimgit"
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
alias tmux="tmux -u"
alias btar="tar --use-compress-program=pbzip2"
alias df="df -h"
alias s="source"

stty stop undef

if [ "`uname|grep CYGWIN`" != "" ]; then
    chcp.com 65001
    alias st="cygstart"
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

# vcs_infoロード    
autoload -Uz vcs_info    
# PROMPT変数内で変数参照する    
setopt prompt_subst    

# vcsの表示    
zstyle ':vcs_info:*' formats '%s|%F{green}%b%f'    
zstyle ':vcs_info:*' actionformats '%s|%F{green}%b%f(%F{red}%a%f)'    
# プロンプト表示直前にvcs_info呼び出し    
precmd() { vcs_info }    

# keychain
keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/`uname -n`-sh
