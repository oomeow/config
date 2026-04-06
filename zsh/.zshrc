# ---------------------------------------------------------------
#               analyze zsh starting, two methods
# 1、zmodload zsh/zprof
# 2、zinit ice atinit'zmodload zsh/zprof' \
#       atload'zprof | head -n 20; zmodload -u zsh/zprof'
# ---------------------------------------------------------------
# zmodload zsh/zprof

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

### zsh-defer
zinit light romkatv/zsh-defer

### zinit annexes
zinit light-mode depth"1" for \
    zdharma-continuum/zinit-annex-binary-symlink \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

### zsh option
setopt promptsubst
# set zsh nomatch for use '*' charactor
setopt no_nomatch

### powerlevel10k theme
zinit ice depth"1"
# zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ========== oh-my-zsh components ==========
### libraries
zinit for \
    OMZL::correction.zsh \
    OMZL::completion.zsh \
    OMZL::history.zsh \
    OMZL::git.zsh \
    OMZL::key-bindings.zsh \
    OMZL::clipboard.zsh \
    OMZL::theme-and-appearance.zsh
### plugins
zinit for \
    OMZP::git
zinit wait'0a' lucid for \
    OMZP::colored-man-pages \
    OMZP::extract \
    OMZP::fancy-ctrl-z \
    OMZP::sudo \
    as"completion" OMZP::docker/completions/_docker
    # svn atload'export SHELLPROXY_URL="http://127.0.0.1:7897";
    # export SHELLPROXY_NO_PROXY="localhost,127.0.0.1"' OMZP::shell-proxy

### completion enhancements
zinit wait"1a" lucid depth"1" for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    blockf \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zsh-users/zsh-history-substring-search

### git extras
zinit wait'0a' depth"1" lucid for \
    as"null" src"etc/git-extras-completion.zsh" lbin'!bin/git-*' tj/git-extras

# zinit ice wait"0b" id-as"eza-completion" lucid as"completion" pick'/completions/zsh/_eza' nocompile
# zinit load eza-community/eza

### zsh-you-should-use
zinit wait"0a" lucid for MichaelAquilina/zsh-you-should-use

### rustup completion
zinit ice wait"0a" if'[[ -n "$commands[rustup]" ]]' id-as"rustup-completion" lucid as"completion" atclone'rustup completions zsh > _rustup' pick'_rustup' nocompile
zinit light zdharma-continuum/null

### cargo completion
zinit ice wait"0a" if'[[ -n "$commands[cargo]" ]]' id-as"cargo-completion" lucid as"completion" atclone'rustup completions zsh cargo > _cargo' pick'_cargo' nocompile
zinit light zdharma-continuum/null

### watchexec completion
zinit ice wait"0a" if'[[ -n "$commands[watchexec]" ]]' id-as"watchexec-completion" lucid as"completion" atclone'watchexec --completions zsh > _watchexec' pick'_watchexec' nocompile
zinit light zdharma-continuum/null

### ollama completion
zinit ice wait"0a" if'[[ -n "$commands[ollama]" ]]' id-as"ollama-completion" lucid as"completion" pick'_ollama' nocompile
zinit light ocodo/ollama_zsh_completion

### ai-commit completion
zinit ice wait"0a" if'[[ -n "$commands[ai-commit]" ]]' id-as"ai-commit-completion" lucid as"completion" pick'completions/zsh/_ai-commit' nocompile
zinit light oomeow/ai-commit

source <(fzf --zsh)

### fzf-tab
zinit ice wait"0a" lucid depth"1" atload"zicompinit; zicdreplay" blockf
zinit load Aloxaf/fzf-tab

###############################
#   fzf-tab preview setting   #
###############################
zstyle ':fzf-tab:*' fzf-pad 4
# zstyle ':fzf-tab:*' fzf-min-height 8
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# ignore fzf-tab when suggestion less than 4
zstyle ':fzf-tab:*' ignore 4
# use group
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group '[' ']'
# cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# kill/ps
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
# systemctl
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
# env variable
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
# git
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'|
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
    'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
    'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
esac'
# man
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

### ========== eval ==========
eval "$(vfox activate zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

### ========== export env ==========
export EDITOR="nvim"
export GPG_TTY=$(tty)
export PATH="$HOME/.local/bin:$PATH"
### maven
# export MAVEN_HOME=/opt/maven
# export PATH=${MAVEN_HOME}/bin:$PATH
### idea
# ___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
### android sdk
# export ANDROID_HOME=$HOME/android/sdk
# export ANDROID_AVD_HOME=$HOME/android/avd
# export PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:$PATH
### go
# export PATH=/usr/local/go/bin:$PATH


### ========== alias ==========
alias cls="clear"
alias sourcezsh="source $HOME/.zshrc"
alias zshrc="nvim $HOME/.zshrc"
alias snvim="sudo -E nvim"
# alias sneovide="sudo -E neovide"
alias ls="eza --icons=always"
alias ll="eza -l --icons=always"
# alias snivm="sudo -E nvim"
# alias sneovide="sudo -E neovide"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/oomeow/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
 
# zprof

