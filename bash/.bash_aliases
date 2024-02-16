# alias ls="exa --icons"
alias apt="nala"
alias bat="batcat"
alias dots="cd $HOME/.dotfiles"
alias ll="ls -lh"
alias la="ls -ah"
alias lal="ls -alh"
alias lla="ls -alh"
alias l=ls
alias t="ls -T"
alias tl="ls -lT"
alias tn="ls --tree --ignore-glob='node_modules'"
alias tnl="ls --ignore-glob='node_modules' -lT"
alias tln="ls --ignore-glob='node_modules' -lT"

# alias rm="rip"

alias f="fg"
alias j="jobs"

alias q="exit"
alias :q="exit"
alias hc="history clear"
alias c="clear"

# code
alias nv="nvim"
alias n="nvim"
alias lg="lazygit"

# markdown
alias glow="glow --pager"

alias h="cd $HOME"
alias goc="cd $HOME/code/"
alias gos="cd $HOME/school/"

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


alias hms="home-manager switch"

# alias oc="dos='~/code/$(/bin/ls ~/code/ | fzf)' ; cd $dos"

alias list-fonts="kitty +list-fonts --psnames"
