set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux HOME "/home/saravenpi"
set -Ux CODE "$HOME/code"
set -Ux SCHOOL "$HOME/school/"
set currentdate = (date)

source ~/.config/fish/aliases.fish
source ~/.config/fish/functions.fish

set fish_greeting ""
starship init fish | source
zoxide init fish | source
