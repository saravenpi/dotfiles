# ls aliases
alias ls="eza --color=always --git --icons=always --no-user"
alias ll="ls -lh"
alias la="ls -ah"
alias lal="ls -alh"
alias lla="ls -alh"
alias l="ls"
alias tn="eza --tree --color=always --git --icons=always --no-user"

# cli tools
alias rm="rip"
alias bat="batcat"

# jobs
alias f="fg"
alias j="jobs"

# shell commands
alias q="exit"
alias :q="exit"
alias c="clear"
alias hc="history clear"

# code
alias nv="nvim"
alias n="nvim"
alias lg="lazygit"
alias k="kettle"

# Quick navigation
alias h="cd $HOME"
alias dots="cd $HOME/.dotfiles"
alias goc="cd $HOME/code/"
alias gos="cd $HOME/school/"
alias gob="cd $HOME/brain/"

# git
alias gs="git status"
alias gp="git push"
alias ga="git add"
alias gc="git clone"
alias gd="git diff"
alias gb="git branch"
alias gr="git remove"
alias gitu="git add . && gitmoji -c && git push"

# clang
alias m="make"
alias mc="make clean"
alias mf="make fclean"
alias mfc="make fclean"
alias mr="make re"
alias mre="mr"
alias vg="valgrind"
alias vgf="valgrind --leak-check=full"

# tmux
alias t="tmux"
alias tl="tmux ls -F '#{session_name}'"
alias tll="tmux ls"
alias trs="tmux rename-session -t"

# nono
alias nono="pokemon-colorscripts -n audino --no-title"
alias fanfan="pokemon-colorscripts -n caterpie --no-title"
