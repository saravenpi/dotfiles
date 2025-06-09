# ls aliases
alias ls="eza --color=always --git --icons=always --no-user"
alias tn="eza --tree --color=always --git --icons=always --no-user"
alias ll="ls -lh"
alias la="ls -ah"
alias lal="ls -alh"
alias lla="ls -alh"
alias l="ls"

# cli tools
alias rm="rip"
alias bat="batcat"

# jobs
alias f="fg"

# shell commands
alias q="exit"
alias :q="exit"
alias c="clear"
alias hc="history clear"
alias breload="clear && source $HOME/.bashrc"
alias brel="breload"
alias zreload="clear && source $HOME/.zshrc"
alias zrel="zreload"
alias treload="tmux source-file ~/.tmux.conf"
alias trel="treload"

# code
alias nv="nvim"
alias n="nvim"
alias lg="lazygit"
alias k="kettle"

# quick navigation
alias h="clear && cd $HOME && welcome"
alias dots="cd $HOME/.dotfiles"
alias goc="cd $HOME/code/"
alias gos="cd $HOME/school/"
alias gob="cd $HOME/brain/"
alias gon="cd $HOME/notes/ && nvim index.md"

OBSIDIAN="$HOME/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/"
alias wk="cd $HOME/notes/ && nvim index.md"
alias b="cd $OBSIDIAN/brain && nvim"

alias streaks="streaks.ts"
alias st="streaks"

# quick config
alias cnvim="cd $HOME/.config/nvim/ && nvim ."
alias cbash="cd $HOME && nvim .bashrc"
alias czsh="cd $HOME && nvim .zshrc"
alias caliases="cd $HOME && nvim .bash_aliases"
alias ctmux="cd $HOME && nvim .tmux.conf"

alias gs="git status"
alias gp="git push"
alias ga="git add"
alias gc="git clone"
alias gd="git diff"
alias gb="git branch"
alias gba="git branch -a"
alias gco="git checkout"
alias gr="git remove"
# alias gitu="git add . && gitmoji -c && git push"
alias gitu="git add . && git commit"
alias gitup="git add . && git commit && git push"

# clang
alias m="make"
alias mc="make clean"
alias mf="make fclean"
alias mfc="make fclean"
alias mr="make re"
alias mre="mr"
alias vg="valgrind"
alias vgf="valgrind --leak-check=full"
alias cinit="kettle use c ."

# tmux
# alias t="tmux"
alias t="tmux" # start tmux
alias tl="tmux ls -F '#{session_name}'" # list sessions
alias sl="tmux ls -F '#{session_name}'" # list sessions
alias tll="tmux ls" # list sessions with details
alias trs="tmux rename-session -t" # remame tmux session

# nono
alias nono="pokemon-colorscripts -n audino --no-title"
alias fanfan="pokemon-colorscripts -n caterpie --no-title"

alias ax="chmod +x"
alias starwars="telnet towel.blinkenlights.nl"
