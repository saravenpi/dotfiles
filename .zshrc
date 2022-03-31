# Created by newuser for 5.8.1

HOME="/home/saravenpi"
CODE="$HOME/Documents/code" SCHOOL="$CODE/epita/" alias ls="exa --icons"
currentdate=$(date)
alias ll="ls -lh"
alias la="ls -ah"
alias lal="ls -alh"
alias lla="ls -alh"
alias l="ls"
alias t="ls -T"
alias tl="ll -T"
alias tn="ls --tree --ignore-glob='node_modules'"
alias tnl="ll --ignore-glob='node_modules' -T"
alias tln="ll --ignore-glob='node_modules' -T"

alias rm="rm -i"

alias f="fg"
alias j="jobs"

alias q="exit"
alias hc="history clear"
alias c="clear"

alias nv="nvim"
alias lv="$HOME/.local/bin/lvim"

alias h="cd $HOME"
alias goc="cd $CODE"
alias gos="cd $SCHOOL"
alias god="cd $CODE/dreamit/"
alias goh="cd $CODE/honive/"
alias gok="cd $CODE/kata/"
alias goi="cd $SCHOOL/IP/"
alias gop="cd $SCHOOL/projets2/"

alias gs="git status"
alias gp="git push"
alias ga="git add"

alias gitu="git add . && git commit && git push"
alias gituf="git add . && git commit -m \" $currentdate \" && git push"

alias pdf="zathura"
alias flex="neofetch"

wk() {
  cur=$(pwd)
  cd "$HOME/vimwiki/"
  nv index.wiki
  cd "$cur"
}

zshc() {
  cur=$(pwd)
  cd "$HOME"
  nv .zshrc
  cd "$cur"
}

nvc() {
  cur=$(pwd)
  cd "$HOME/.config/nvim/"
  nv init.lua
  cd "$cur"
}

gc() {
  git clone "https://github.com/$1"
}

eval "$(starship init zsh)"
export PATH="$PATH:$HOME/.spicetify"
