
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

source ~/.zplug/zplug

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"

zplug "junegunn/dotfiles", as:command, use:bin/vimcat

zplug "tcnksm/docker-alias", use:zshrc

# frozen: を指定すると全体アップデートのときアップデートしなくなる（デフォルトは0）
zplug "k4rthik/git-cal", as:command

zplug "junegunn/fzf-bin", \
    as:command, \
    from:gh-r, \
    rename-to:fzf

zplug "plugins/git", from:oh-my-zsh

# ビルド用 hook になっていて、この例ではクローン成功時に make install する
# シェルコマンドなら何でも受け付けるので "echo OK" などでも可
zplug "tj/n", hook-build:"make install"

# ブランチロック・リビジョンロック
# at: はブランチとタグをサポートしている
zplug "b4b4r07/enhancd", at:v1
zplug "mollifier/anyframe", at:4c23cb60

# if: を指定すると真のときのみロードを行う（クローンはする）
zplug "hchbaw/opp.zsh", if:"(( ${ZSH_VERSION%%.*} < 5 ))"

# from: では gist を指定することができる
# gist のときもリポジトリと同様にタグを使うことができる
zplug "b4b4r07/79ee61f7c140c63d2786", \
    from:gist, \
    as:command, \
    use:get_last_pane_path.sh

zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

ZSH_THEME="afowler"

zplug load --verbose

# git setting
autoload -U colors; colors

function rprompt-git-current-branch
{
    local name st color

    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
            return
    fi
    name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
    if [[ -z $name ]]; then
            return
    fi
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
            color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
            color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
            color=${fg_bold[red]}
    else
            color=${fg[red]}
    fi

    echo "%{$color%}$name%{$reset_color%} "
}

# prompt
setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'

# ssh-agent setting
if [ -f ~/.ssh-agent ]; then
    . ~/.ssh-agent
fi
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 $SSH_AGENT_PID; then
    ssh-agent > ~/.ssh-agent
    . ~/.ssh-agent
fi
ssh-add -l >& /dev/null || ssh-add
