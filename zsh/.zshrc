### analyze zsh starting, two methods
# 1、zmodload zsh/zprof
# 2、zi ice atinit'zmodload zsh/zprof' \
    # atload'zprof | head -n 20; zmodload -u zsh/zprof'


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
zi light romkatv/zsh-defer

### zinit annexes
zi light-mode depth"1" for \
    zdharma-continuum/zinit-annex-binary-symlink \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

### zsh option
setopt promptsubst
# set zsh nomatch for use '*' charactor
setopt no_nomatch

### powerlevel10k theme
zi ice depth"1"
zi light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
zi wait'0a' lucid light-mode for \
    OMZP::colored-man-pages \
    OMZP::extract \
    OMZP::fancy-ctrl-z \
    OMZP::sudo \
    OMZP::z \
    as"completion" \
    OMZP::docker/completions/_docker \
    svn atload'export SHELLPROXY_URL="http://127.0.0.1:7897";
export SHELLPROXY_NO_PROXY="localhost,127.0.0.1";
proxy enable' \
    OMZP::shell-proxy

### completion enhancements
zi wait"0a" lucid depth"1" light-mode for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    blockf \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zsh-users/zsh-history-substring-search

### git extras
zi wait'0a' depth"1" lucid light-mode for \
    as"null" src"etc/git-extras-completion.zsh" lbin="!bin/git-*" tj/git-extras

### eza
zi ice wait"0a" lucid from"gh-r" as"program" pick"eza" atload'alias ls="eza --icons=always"; alias ll="eza -l --icons=always"'
zi light eza-community/eza
zi ice wait"0b" id-as"eza-completion" lucid as"completion" pick'/completions/zsh/_eza' nocompile
zi light eza-community/eza

### delta [git changed file preview]
zi ice wait"0a" lucid from"gh-r" as"program" mv"delta* -> delta" pick"delta/delta"
zi light dandavison/delta

### zsh-you-should-use
zi wait"0a" lucid light-mode for MichaelAquilina/zsh-you-should-use

### bat [replace cat command]
zi ice wait"0a" lucid light-mode from'gh-r' as"program" mv"bat* -> bat" pick"bat/bat"
zi light @sharkdp/bat

### fzf
zi wait"0a" lucid pack"bgn-binary+keys" for fzf

### fd
zi wait"0a" lucid \
    from"gh-r" id-as"@sharkdp/fd" mv"fd* -> fd" pick"/dev/null" sbin"fd/fd" \
    for @sharkdp/fd

### fzf-tab
zi ice wait"0a" lucid depth"1" atload"zicompinit; zicdreplay" blockf
zi light Aloxaf/fzf-tab

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
zi ice if'[[ -d "/home/linuxbrew/.linuxbrew/" ]]' id-as"brew_completion" as"null" \
    atinit'!eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"' \
    atload'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"; zicompinit; zicdreplay'
zi light zdharma-continuum/null

### conda - init and completion
zsh-defer zinit light-mode lucid for commiyou/conda-init-zsh-plugin
zi wait"0a" lucid light-mode for conda-incubator/conda-zsh-completion

### neovim
zi ice wait"0a" lucid from"gh-r" ver"nightly" as"program" mv"nvim-* -> nvim" pick"nvim/bin/nvim" \
    atload'alias zshrc="nvim $HOME/.zshrc"; alias snvim="sudo -E nvim"; export EDITOR=nvim'
zi light neovim/neovim
# TODO change `your_password` to your password
zi ice wait"1" if'[[ ! -f /usr/bin/nvim ]]' id-as"root-user-nvim-link" has"nvim" as"null" lucid \
    atclone'echo "your_password" | sudo -S ln -s $(which nvim) /usr/bin/nvim'
zi light zdharma-continuum/null

### neovide
zi ice wait"0b" lucid from"gh-r" as"program" sbin'neovide' atload'alias sneovide="sudo -E neovide"'
zi light neovide/neovide
# TODO change `your_password` to your password
zi ice wait"1" if'[[ ! -f /usr/bin/neovide ]]' id-as"root-user-neovide-link" has"neovide" as"null" lucid \
    atclone'echo "your_password" | sudo -S ln -s $(which neovide) /usr/bin/neovide'
zi light zdharma-continuum/null

### follow plugins are ready for AstroNvim
# ripgrep / lazygit / gdu [disk usage] / bottom [process viewer]
zi wait"0a" lucid from"gh-r" as"program" for \
    mv"ripgrep* -> rg" pick"rg/rg" nocompletions BurntSushi/ripgrep \
    sbin"lazygit" jesseduffield/lazygit \
    mv"gdu* -> gdu" pick"gdu" dundee/gdu \
    sbin"btm" src"completion/_btm" ClementTsang/bottom

### jenv [java version manager]
zi light-mode lucid for \
    as"program" pick"bin/jenv" src"completions/jenv.zsh" jenv/jenv \
    @shihyuho/zsh-jenv-lazy

### sdkman
# zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
    #     atclone"wget https://get.sdkman.io/ -O scr.sh; SDKMAN_DIR=$ZPFX/sdkman bash scr.sh" \
    #     atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
    #     atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
# zinit light zdharma-continuum/null

### fnm [node version manager]
zi ice from"gh-r" as"program" sbin'fnm' atload'eval "$(fnm env --use-on-cd)"'
zi light @Schniz/fnm
zi ice id-as"fnm_completion" has"fnm" as"completion" \
    atclone'fnm completions --shell zsh > _fnm' pick'_fnm' nocompile
zi light zdharma-continuum/null

### fvm [flutter version manager]
zi ice from"gh-r" as"program" sbin'fvm/fvm' \
    atload'export PUB_HOSTED_URL=https://pub.flutter-io.cn;
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn; export PATH=$HOME/fvm/default/bin:$PATH'
zi light leoafarias/fvm


### ========== export env ==========
### fzf
if type fzf > /dev/null 2>&1; then
    export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git'"
    export FZF_DEFAULT_OPTS='--preview-window=right,50%,border-top'
fi
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


### ========== alias ==========
### change gtk4 theme script
alias change-theme="python ${HOME}/.change_gtk4_theme.py"
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
