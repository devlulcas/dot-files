export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

zstyle ':omz:update' frequency 14

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	asdf
)

source $ZSH/oh-my-zsh.sh

# preferences
export EDITOR=nvim

# run alias command to see all aliases
alias vim="nvim"
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias cat="bat"
alias see="viu"
alias wcp="wl-copy"
alias wps="wl-paste"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# end pnpm

# android sdk
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
# end android sdk

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
# end deno

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
# end go

# rebar - erlang / elixir / gleam
export REBAR3PATH="$HOME/.cache/rebar3/bin"
export PATH="$REBAR3PATH:$PATH"
# end rebar

# turso
export PATH="$HOME/.turso:$PATH"
# end turso

# inline bc command + colors
ibc() {
	local result=bc<<<"$@"
	echo -e "\n\033[1;33m$@\033[0m = \033[0;32m$result\033[0m\n"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
. "$HOME/.asdf/asdf.sh"

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
