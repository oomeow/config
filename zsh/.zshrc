### analyze zsh starting, two methods
# 1、zmodload zsh/zprof
# 2、zinit ice atinit'zmodload zsh/zprof' \
    # atload'zprof | head -n 20; zmodload -u zsh/zprof'

# zmodload zsh/zprof


# =======================================
# shell proxy [ important!!! ]
# =======================================
alias proxyset="export http_proxy=http://127.0.0.1:7897; export https_proxy=http://127.0.0.1:7897"
alias proxyunset="unset http_proxy; unset https_proxy"
# proxyset


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
zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
zinit wait"0a" lucid depth"1" for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    blockf \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zsh-users/zsh-history-substring-search

### git extras
zinit wait'0a' depth"1" lucid for \
    as"null" src"etc/git-extras-completion.zsh" lbin'!bin/git-*' tj/git-extras

### eza
zinit ice wait"0a" lucid from"gh-r" as"program" pick"eza" \
    atload'alias ls="eza --icons=always"; alias ll="eza -l --icons=always"'
zinit load eza-community/eza
zinit ice wait"0b" id-as"eza-completion" lucid as"completion" pick'/completions/zsh/_eza' nocompile
zinit load eza-community/eza

### delta [git changed file preview]
zinit ice wait"0a" lucid from"gh-r" as"program" mv"delta* -> delta" pick"delta/delta"
zinit load dandavison/delta

### zsh-you-should-use
zinit wait"0a" lucid for MichaelAquilina/zsh-you-should-use

### zoxide
zinit ice wait"0a" lucid from"gh-r" as"program" pick"zoxide" src"completions/_zoxide" \
    atload'!eval "$(zoxide init zsh)"'
zinit load ajeetdsouza/zoxide

### bat [replace cat command]
zinit ice wait"0a" lucid from'gh-r' as"program" mv"bat* -> bat" pick"bat/bat"
zinit load @sharkdp/bat

### fzf
zinit wait"0a" lucid pack"bgn-binary+keys"  \
    atinit"!export FZF_CTRL_T_COMMAND=\"fd --type f --hidden --follow --exclude .git ||
git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git'\"; 
export FZF_DEFAULT_OPTS=\"--preview-window=right,50%,border-top\"" for fzf

### fd
zinit wait"0a" lucid \
    from"gh-r" mv"fd* -> fd" pick"/dev/null" sbin"fd/fd" \
    for @sharkdp/fd

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

### homebrew
zinit ice if'[[ -d "/home/linuxbrew/.linuxbrew/" ]]' id-as"brew_completion" as"null" \
    atinit'!eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"' \
    atload'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"; zicompinit; zicdreplay'
zinit light zdharma-continuum/null

### conda - init and completion
zsh-defer zinit lucid for commiyou/conda-init-zsh-plugin
zinit wait"0a" lucid for conda-incubator/conda-zsh-completion

### neovim
zinit ice wait"0a" lucid from"gh-r" as"program" mv"nvim-* -> nvim" pick"nvim/bin/nvim" \
    atload'alias zshrc="nvim $HOME/.zshrc"; alias snvim="sudo -E nvim"; export EDITOR=nvim'
zinit load neovim/neovim
# TODO: change `your_password` to your password
zinit ice wait"1" if'[[ ! -f /usr/bin/nvim ]]' id-as"root-user-nvim-link" has"nvim" as"null" lucid \
    atclone'echo "your_password" | sudo -S ln -s $(which nvim) /usr/bin/nvim'
zinit load zdharma-continuum/null

### neovide
zinit ice wait"0b" lucid from"gh-r" as"program" sbin'neovide' atload'alias sneovide="sudo -E neovide"'
zinit load neovide/neovide
# TODO: change `your_password` to your password
zinit ice wait"1" if'[[ ! -f /usr/bin/neovide ]]' id-as"root-user-neovide-link" has"neovide" as"null" lucid \
    atclone'echo "your_password" | sudo -S ln -s $(which neovide) /usr/bin/neovide'
zinit load zdharma-continuum/null

### follow plugins are ready for AstroNvim
# ripgrep / lazygit / gdu [disk usage] / bottom [process viewer]
zinit wait"0a" lucid from"gh-r" as"program" for \
    mv"ripgrep* -> rg" pick"rg/rg" nocompletions BurntSushi/ripgrep \
    sbin"lazygit" jesseduffield/lazygit \
    mv"gdu* -> gdu" pick"gdu" dundee/gdu \
    sbin"btm" src"completion/_btm" ClementTsang/bottom

### jenv [java version manager]
zinit lucid for \
    as"program" pick"bin/jenv" src"completions/jenv.zsh" jenv/jenv \
    @shihyuho/zsh-jenv-lazy

### sdkman
# zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
    #     atclone"wget https://get.sdkman.io/ -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
    #     atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
    #     atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
# zinit light zdharma-continuum/null

### fnm [node version manager]
zinit ice from"gh-r" as"program" sbin'fnm' atload'eval "$(fnm env --use-on-cd)"'
zinit light @Schniz/fnm
zinit ice id-as"fnm_completion" has"fnm" as"completion" \
    atclone'fnm completions --shell zsh > _fnm' pick'_fnm' nocompile
zinit light zdharma-continuum/null

### fvm [flutter version manager]
zinit ice from"gh-r" as"program" sbin'fvm/fvm' \
    atload'export PUB_HOSTED_URL=https://pub.flutter-io.cn;
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn; export PATH=$HOME/fvm/default/bin:$PATH'
zinit light leoafarias/fvm


### ========== export env ==========
### maven
export MAVEN_HOME=/opt/maven
export PATH=${MAVEN_HOME}/bin:$PATH
### jetbrains ideas active script
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
### android sdk
export ANDROID_HOME=$HOME/android/sdk
export ANDROID_AVD_HOME=$HOME/android/avd
export PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:$PATH
### spicetify [custom spotify theme]
export PATH=$HOME/.spicetify:$PATH
### go
export PATH=/usr/local/go/bin:$PATH


### ========== alias ==========
### change gtk4 theme script
alias change-theme="python $HOME/.change_gtk4_theme.py"
alias sourcezsh="source $HOME/.zshrc"
if type deborphan > /dev/null 2>&1; then
    alias cleanOS="sudo apt-get remove --purge `deborphan`"
fi

### ========== function ==========
### change brightness
function change-brightness() {
    local light=0.9
    if [ "$#" -eq 1 ]; then
        local light="$1"
    fi
    local monitors=($(xrandr --query | grep " connected" | cut -d" " -f1))
    for monitor in $monitors; do
        xrandr --output $monitor --brightness $light
    done
}

# zprof
