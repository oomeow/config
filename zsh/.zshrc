### analyze zsh starting, two methods
# 1、zmodload zsh/zprof
# 2、zinit ice atinit'zmodload zsh/zprof' \
    # atload'zprof | head -n 20; zmodload -u zsh/zprof'


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

### zinit annexes
zi light-mode depth"1" for \
    zdharma-continuum/zinit-annex-binary-symlink \
    zdharma-continuum/zinit-annex-patch-dl

### zsh option
setopt promptsubst
# set zsh nomatch, when use '*' charactor
setopt no_nomatch

### powerlevel10k theme
zi ice depth"1"
zi light romkatv/powerlevel10k

# zsh-defer
zi light romkatv/zsh-defer

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### git extras
zi lucid wait'0a' depth"1" for \
    as"null" src"etc/git-extras-completion.zsh" lbin="!bin/git-*" tj/git-extras

# ========== oh-my-zsh components ==========
### libraries
zi for \
    OMZL::correction.zsh \
    OMZL::completion.zsh \
    OMZL::history.zsh \
    OMZL::git.zsh \
    OMZL::key-bindings.zsh \
    OMZL::clipboard.zsh \
    OMZL::theme-and-appearance.zsh

### plugins
zi for \
    OMZP::git

zi light-mode wait'0a' lucid for \
    OMZP::colored-man-pages \
    OMZP::extract \
    OMZP::fancy-ctrl-z \
    OMZP::sudo \
    OMZP::z \
    as"completion" \
    OMZP::docker/completions/_docker \
    svn atload'export SHELLPROXY_URL="http://127.0.0.1:7890"; export SHELLPROXY_NO_PROXY="localhost,127.0.0.1"' \
    OMZP::shell-proxy

### completion enhancements
zi light-mode wait lucid depth"1" for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    blockf \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zsh-users/zsh-history-substring-search

### zsh-you-should-use
zi light-mode wait lucid for MichaelAquilina/zsh-you-should-use

### LS_COLORS
# zi ice wait lucid atclone"dircolors -b LS_COLORS > clrs.zsh" \
    #     atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    #     atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
# zi light trapd00r/LS_COLORS

### Homebrew
zinit ice id-as"brew_completion" \
    atinit'!eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"' \
    atload'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"; zicompinit; zicdreplay'
zi light zdharma-continuum/null
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# if type brew &>/dev/null
# then
#     FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
#
#     autoload -Uz compinit
#     compinit
# fi

### conda - init and completion
zsh-defer zinit light commiyou/conda-init-zsh-plugin
zi light-mode wait"0a" lucid for conda-incubator/conda-zsh-completion

### fzf
zi ice wait lucid from"gh-r" nocompile src'key-bindings.zsh' lbin"!fzf" \
    dl'https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh -> $ZINIT[COMPLETIONS_DIR]/_fzf_completion;
https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -> key-bindings.zsh;
https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf-tmux.1 -> $ZPFX/man/man1/fzf-tmux.1;
https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 -> $ZPFX/man/man1/fzf.1'
zi light junegunn/fzf
# fzf-tab
zi ice wait lucid depth"1" atload"zicompinit; zicdreplay" blockf
zi light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:*' fzf-min-height 8
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_DEFAULT_OPTS='--border'


### ========== export env ==========

### jenv [java version manager]
export PATH="$HOME/.jenv/bin:$PATH"
# zi ice wait lucid id-as"jenv_init" atinit"!eval '$(jenv init -)'"
zi ice id-as"jenv_init" atinit"!eval '$(jenv init -)'"
zi light zdharma-continuum/null
# eval "$(jenv init -)"

### maven
export MAVEN_HOME=/opt/maven
export PATH=${MAVEN_HOME}/bin:$PATH

### fnm [node version manager]
export PATH="/home/hua/.local/share/fnm:$PATH"
# zi ice wait lucid id-as"fnm_init" atinit"!eval '$(fnm env)'"
zi ice id-as"fnm_init" atinit"!eval '$(fnm env)'"
zi light zdharma-continuum/null
# eval "$(`fnm env`)"

### flutter mirrors
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

### set fvm global flutter sdk
export PATH=/home/hua/fvm/default/bin:$PATH

### jetbrains ideas active script
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

### android sdk
export ANDROID_HOME=$HOME/android/sdk
export ANDROID_AVD_HOME=$HOME/android/avd
export PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:$PATH

### add spicetify(custom spotify theme) command
export PATH=$PATH:/home/hua/.spicetify


### ========== alias ==========

### change gtk4 theme script
alias changeGTK4Theme="python ${HOME}/.change_gtk4_theme.py"
alias changeBrightness="xrandr --output eDP --brightness 0.9 && xrandr --output HDMI-1-0 --brightness 0.9"
alias sourcezsh="source $HOME/.zshrc"
alias ls="exa"
alias ll="exa -l"
