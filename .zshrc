#PROMPT_STR=$'(`basename \"$VIRTUAL_ENV\"`) %{\e[31m%}%n%{\e[m%}@%{\e[32m%}%m%{\e[m%}:${vcs_info_msg_0_}|(%1v, $$)|$(get_cpu_info)|%D{%Y/%m/%d %H:%M} %{\e[1;33m%}%~%{\e[m%}\n%{%(?.$bg[black].$bg[red])%}%#%#%#%{$reset_color%} '
PROMPT_STR=$'%{\e[31m%}%n%{\e[m%}@%{\e[32m%}%m%{\e[m%}|(%1v, $$)|%D{%Y/%m/%d %H:%M} %{\e[1;33m%}%~%{\e[m%}\n%{%(?.$bg[black].$bg[red])%}%#%#%#%{$reset_color%} '
PS4_STR='[%D{%Y/%m/%d %H:%M:%S.%6.} ]+ '
PROMPT=${PROMPT_STR}
PS4=${PS4_STR}

bindkey -e

#VIM=nvim
VIM=vim
export EDITOR=${VIM}
export PATH=~/bin:~/utils/:${PATH}:~/.local/bin:~/.cargo/bin
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export no_proxy=localhost,127.0.0.0/8,::1
export PERL5LIB=${MISC_DIR}
export REPORTTIME=3
export MDV_THEME="896.1635"

# dir color
eval `dircolors ${MISC_DIR}/.colorrc`

#
# cdr
#
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true


# pet
call_pet () {
    local snippets=$(pet --config ${MISC_DIR}/pet_config.toml search | cat)
    LBUFFER="${LBUFFER}${snippets}"
    zle reset-prompt
}
zle -N call_pet
bindkey '^x^x' call_pet

#
# history settings {{{
#
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
#setopt share_history
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    # 以下の条件をすべて満たすものだけをヒストリに追加する
    [[ ${#line} -ge 3
        && ${cmd} != (l|l[sal])
        && ${cmd} != fg
    ]]
}
# }}}

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

autoload -Uz compinit && compinit
autoload -Uz colors && colors
autoload -Uz zmv

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt auto_pushd
setopt noautoremoveslash
setopt auto_param_slash
setopt magic_equal_subst
setopt auto_cd
setopt extended_glob

zstyle ':completion:*:default' menu select=1

#ulimit -c 100000000
#ulimit -s 1000000

#
# aliases {{{
#
alias b="bd"
alias bp="echo $'\a'"
alias btar="tar --use-compress-program=pbzip2"
alias btarc="tar --use-compress-program=pbzip2 -cf"
alias c="cd"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1"
alias dck="docker"
alias df="df -h"
function myfg() { fg %$1 }
alias f="myfg"
alias g="git"
alias gr="grep --color=always"
alias h="history"
function incp() {
    local new_name=$(echo $1 | perl -ne 'if(/(.*)(\d+)(.*)$/) { print $1 . (int($2)+1) . $3; }')
    cp -v $1 $new_name
}
function incpe() {
    local new_name=$(echo $1 | perl -ne 'if(/(.*)(\d+)(.*)$/) { print $1 . (int($2)+1) . $3; }')
    cp -v $1 $new_name
    vim $new_name
}
alias j="jobs"
alias java='java -Dfile.encoding=UTF-8'
alias javac='javac -J-Dfile.encoding=UTF-8'
alias Kill='kill -9'
alias l="ls -F --color=auto"
alias ll="ls -F --color=auto -l"
alias llh="ls -F --color=auto -l -h"
alias lr="ls -ltc"
alias ls="ls -F --color=auto"
alias lv='lv -c'
alias m="make"
#alias man='(){ tmpfile=$(mktemp); man $1 | col -b | bat -l Manpage -p > ${tmpfile} ; view ${tmpfile} -c ":set ft=man" ; rm ${tmpfile}}'
alias md='md5sum'
alias n="ninja"
alias ncl="ninja -t clean"
alias ng="noglob"
alias nv="nvim"
alias p2="python2"
alias p3="python3"
alias p="python"
alias perl="perl -W"
alias pet="pet --config ${MISC_DIR}/pet_config.toml"
alias po="perl -W -MOneLinerLib"
alias pon="perl -MOneLinerLib -W -nE"
alias parallel='parallel --gnu'
alias pd="popd"
alias pytest="pytest -rap --tb=line"
alias q="vim _.sh"
alias r="bash -x _.sh"
alias rg="rg --color=always"
alias rp="realpath"
alias s="source"
alias ssh='ssh -Y'
alias tp="top"
alias t="tmux -u"
alias ta="t a"
alias tig="env LANG=ja_JP.UTF-8 tig status"
alias tiv="tiv_wrapper"
tiv_wrapper () {
    tmpfile=$(mktemp --suffix=.jpg)
    trap 'rm ${tmpfile} ; trap INT PIPE TERM EXIT' INT PIPE TERM EXIT

    identify $1
    convert -resize 256x256 $1 ${tmpfile}
    \tiv ${tmpfile}
}
alias ul="ulimit -c 1000000000"
alias ulimc="ulimit -c 1000000000"
alias v="${VIM}"
alias vc="${VIM} -c AnsiEsc"
alias vd="${VIM} -d"
alias vg="vimgit"
alias vgd="${VIM} -c \":Gdiff\""
alias vimbin='${VIM} -c ":BinEdit'
alias vimgit="${VIM} -c \":Git\""
alias vimps="${VIM} -c \":new | :wincmd o | :PsThisBuffer\""
alias xtar="tar --use-compress-prog=pxz"
alias xtarc="tar --use-compress-prog=pxz -cf"
alias xxd='xxd -g 1'
alias zmvw="noglob zmv -W"
alias ztar="tar --use-compress-prog=pigz"
alias ztarc="tar --use-compress-prog=pigz -cf"
# }}}

#
# g aliases {{{
#
LOG_FILE_NAME='log'
alias -g L='2>&1 |less -R'
alias -g G='2>&1 |grep --color=always'
alias -g RL='> ${LOG_FILE_NAME} 2>&1'
alias -g TL='2>&1 |tee ${LOG_FILE_NAME}'
alias -g TLA='2>&1 |tee -a ${LOG_FILE_NAME}'
alias -g TLH='2>&1 |tee ~/${LOG_FILE_NAME}'
alias -g BP='; bp'
alias -g FF='2>&1 | ff'
alias -g B='| read -d "" _TMUX_BUFF_TMP ; tmux set-buff ${_TMUX_BUFF_TMP}'
# }}}

# 
# s aliases
#
alias -s tgz="ztar -xvf"
alias -s tbz="btar -xvf"
alias -s txz="xtar -xvf"

if [ "`uname|grep CYGWIN`" != "" ]; then
    chcp.com 65001
    alias st="cygstart"
fi

stty stop undef
stty -ixon -ixoff

# vcs_infoロード    
#autoload -Uz vcs_info    
#setopt prompt_subst    
#
## vcsの表示    
#zstyle ':vcs_info:*' formats '%s|%F{green}%b%f'    
#zstyle ':vcs_info:*' actionformats '%s|%F{green}%b%f(%F{red}%a%f)'    
#
#is_in_array() {
#    word=$1
#    shift
#
#    for elm in "$@"; do
#        if [[ $elm == $word ]]; then
#            return 1
#        fi
#    done
#    return 0
#}
#
#precmd() {
#    #echo "cur_cmd: " $CUR_CMD
#    #
#    # コマンド実行時間が長い場合かかった時間を表示
#    #
#    exceptions=(vim v vg vd)
#
#    TIME_END=`date +%s`
#    if [ "${TIME_START}" != "" ] && [ $((${TIME_END} - ${TIME_START} > 10)) -eq 1 ] ; then
#        if is_in_array $CUR_CMD ${exceptions[@]} ; then
#            echo -e "\a"
#        fi
#    fi
#
#    #
#    # プロンプト関連
#    #
#    #vcs_info
#
#    psvar=()
#    psvar[1]=$(jobs | wc -l);
#    PROMPT=${PROMPT_STR}
#    PS4=${PS4_STR}
#
#    printf "\033k%s\033\\" $(basename $(pwd))
#}

#preexec() {
#    CUR_CMD=$(echo $1 | cut -d' ' -f 1)
#    TIME_START=`date +%s`
#}
#
#get_cpu_info() {
#    echo -n %F{cyan}
#    cat /proc/cpuinfo | grep "model name" | uniq | perl -ne '
#    if(/model name\s+:\s+(.+)$/) {
#        print "$1";
#    }
#    '
#    echo -n \(x$(nproc)\)
#    echo -n %F{reset_color}
#}
#
# keychain
keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/`uname -n`-sh

#
# recompile zsh scripts {{{
#
if [ ! -f ${MISC_DIR}/.zshrc.zwc -o ${MISC_DIR}/.zshrc -nt ${MISC_DIR}/.zshrc.zwc ]; then
   zcompile ${MISC_DIR}/.zshrc
fi
if [ ! -f ${MISC_DIR}/.fzf.zsh.zwc -o ${MISC_DIR}/.fzf.zsh -nt ${MISC_DIR}/.fzf.zsh.zwc ]; then
   zcompile ${MISC_DIR}/.fzf.zsh
fi
if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi
# }}}


#
# plugins
#
source ${MISC_DIR}/zinit/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma-continuum/fast-syntax-highlighting
FAST_HIGHLIGHT=(main brackets)
FAST_HIGHLIGHT_STYLES[globbing]='fg=cyan'
FAST_HIGHLIGHT[use_brackets]=1
zinit ice from"gh-r" as"program"

zinit light junegunn/fzf
zinit pack"default+keys" for fzf
source ${MISC_DIR}/.fzf.zsh

zinit light supercrabtree/k
zinit light zsh-users/zsh-history-substring-search
bindkey "^${key[Up]}" history-substring-search-up
bindkey "^${key[Down]}" history-substring-search-down
bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history
bindkey "^P" up-line-or-local-history
bindkey "^N" down-line-or-local-history
up-line-or-local-history() {
    zle set-local-history 1
    #zle up-line-or-history
    zle history-substring-search-up
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    #zle down-line-or-history
    zle history-substring-search-down
    zle set-local-history 0
}
zle -N down-line-or-local-history
zinit light "urbainvaes/fzf-marks"
zinit light "Tarrasch/zsh-bd"

#
# additional keybinding settings
#
bindkey -r "^O"
bindkey '^t' kill-word
bindkey '^j' undo
bindkey '^o^u' undo
bindkey '^o^d' kill-word
bindkey '^o^b' backward-word
bindkey '^o^f' forward-word
zle     -N   fr
bindkey "^x^r" fr
zle -C _complete_files complete-word complete-files
complete-files () { compadd - $PREFIX* }
function cd-up { zle push-line && LBUFFER='builtin cd ..' && zle accept-line }
zle -N cd-up
#bindkey "^O" cd-up
