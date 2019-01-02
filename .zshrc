#PS1='%1v %2v'
PROMPT=$'%{\e[31m%}%n%{\e[m%}@%{\e[32m%}%m%{\e[m%}:${vcs_info_msg_0_}:(%1v) %{\e[1;33m%}%~%{\e[m%}\n%# '
export EDITOR='vim'
export PATH=~/bin:~/utils/:${PATH}
export TERM=xterm-256color


#
# fzf
#
source ~/.fzf.zsh
# fd - cd to selected directory
fd() {
  local dir
  dir=$(find -maxdepth 2 -type d -o -type l 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fr
fr() {
  local dir
  dir=$(cdr -l 2> /dev/null | awk '{ print $2 }' | fzf +m) &&
  cd `eval echo $dir`
}

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fk - kill process
fK() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}
fk() {
  local pid
  pid=$(ps -f | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}


# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  tags=$(
git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
git branch --all | grep -v HEAD |
sed "s/.* //" | sed "s#remotes/[^/]*/##" |
sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
(echo "$tags"; echo "$branches") |
    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
        --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
  git checkout $(echo "$target" | awk '{print $2}')
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
#bindkey "^R" history-incremental-search-backward
zle     -N   fh
bindkey "^x^r" fh
#bindkey "^T" history-incremental-search-forward
zle     -N   fr
bindkey "^x^e" fr
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

ulimit -c 100000000
ulimit -s 100000

alias r="anyframe-widget-cdr"
alias v="vim"
alias vv="vim ."
alias c="cd"
alias b="bg"
alias c="cd"
alias e="export"
alias f="myfg"
alias g="git"
alias j="jobs"
alias k="kill -9"
alias K="kill -9 %"
alias ls="ls -F --color=auto"
alias l="ls -F --color=auto"
alias m="make"
alias t="tmux -u"
alias p="python"
alias p2="python2"
alias p3="python3"
alias ulimc="ulimit -c 1000000000"
alias man='(){ man $1 | col -b | view -}'
alias xxd='xxd -g 1'
alias u='cd ..'

LOG_FILE_NAME='log'
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
alias -g RL='> ${LOG_FILE_NAME} 2>&1'
alias -g TL='2>&1 |tee ${LOG_FILE_NAME}'
alias -g TLA='2>&1 |tee -a ${LOG_FILE_NAME}'
alias -g TLH='2>&1 |tee ~/${LOG_FILE_NAME}'
alias C="source ~/.vimrc.cwd"
function myglobal() { global --color=always --result grep -g -o $1 -S $2 $argv[3,-1] }
alias gg="myglobal"
alias gu="global -uv"
function myfg() { fg %$1 }
alias f="myfg"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1"
alias gpom="git push origin master"
alias tmux="tmux -u"
alias btar="tar --use-compress-program=pbzip2"
alias df="df -h"
alias s="source"
alias ust="stty stop undef"
alias nv="nvim"

stty stop undef
stty -ixon -ixoff

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
precmd() {
    psvar=()
    psvar[1]=$(jobs|wc -l);
    vcs_info 
}

# keychain
keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/`uname -n`-sh
