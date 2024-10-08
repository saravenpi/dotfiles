alias ls "eza --icons"
alias apt nala
alias bat batcat
alias dots "cd ~/.dotfiles/"
abbr ll "ls -lh"
abbr la "ls -ah"
abbr lal "ls -alh"
abbr lla "ls -alh"
abbr l ls
abbr t "ls -T"
abbr tl "ls -lT"
abbr tn "ls --tree --ignore-glob='node_modules'"
abbr tnl "ls --ignore-glob='node_modules' -lT"
abbr tln "ls --ignore-glob='node_modules' -lT"


abbr rm "rm -i"

abbr f fg
abbr j jobs

abbr q exit
abbr hc "history clear"
abbr c clear

# code
abbr ] "nvim ."
abbr n nvim
abbr nv nvim
abbr lg lazygit

# markdown
abbr glow "glow --pager"

abbr h "cd $HOME"
abbr goc "cd $CODE"
abbr gos "cd $SCHOOL"

# git
abbr gs "git status"
abbr gp "git push"
abbr ga "git add"
abbr gc "git clone"
abbr gd "git diff"
abbr gb "git branch"
abbr gr "git remove"


abbr gitu "git add . && git commit && git push"

# clang
abbr bb abricot --ignore
abbr m make
abbr mc "make clean"
abbr mf "make fclean"
abbr mfc "make fclean"
abbr mr "make re"
abbr mre mr
abbr csc "$HOME/.coding-style.sh . . &> /dev/null; bat coding-style-reports.log; rm -f coding-style-reports.log"
abbr vg valgrind
abbr vgf "valgrind --leak-check=full"

abbr :q exit

abbr hms "home-manager switch"

alias oc "set dos '~/code/(/bin/ls ~/code/ | fzf)' ; cd $dos"

abbr list-fonts "kitty +list-fonts --psnames"

alias x "xclip -selection clipboard"
