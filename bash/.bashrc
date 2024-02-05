. ~/.bash_aliases
. ~/.bash_functions

# history
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
# . "$HOME/.cargo/env"

# starship
__main() {
	local major="${BASH_VERSINFO[0]}"
	local minor="${BASH_VERSINFO[1]}"

	if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
		source <(/usr/local/bin/starship init bash --print-full-init)
	else
		source /dev/stdin <<<"$(/usr/local/bin/starship init bash --print-full-init)"
	fi
}
__main
unset -f __main

pokemon-colorscripts -r
