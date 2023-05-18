alias ls "exa --icons"
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

abbr z zoxide
abbr q exit
abbr hc "history clear"
abbr c clear

abbr ] "nvim"
abbr n nvim
abbr nv nvim
abbr lg lazygit

abbr h "cd $HOME"
abbr goc "cd $CODE"
abbr gos "cd $SCHOOL"

abbr gs "git status"
abbr gp "git push"
abbr ga "git add"
abbr gc "git clone"
abbr gd "git diff"
abbr gb "git branch"
abbr gr "git remove"

abbr gitu "git add . && git commit && git push"
# abbr gituf "git add . && git commit -m \"$currentdate \"&& git push"

abbr bb abricot --ignore
abbr m make
abbr mc "make clean"
abbr mf "make fclean"
abbr mfc "make fclean"
abbr mr "make re"
abbr mre mr
abbr csc "sh $HOME/.coding-style.sh . . &> /dev/null; bat coding-style-reports.log; rm -f coding-style-reports.log"
abbr vg valgrind
abbr vgf "valgrind --leak-check=full"

abbr :q exit

abbr i3bye "i3-msg exit"
abbr s sgpt

alias oc "set dos '~/code/(/bin/ls ~/code/ | fzf)' ; cd $dos"

abbr list-fonts "kitty +list-fonts --psnames"

abbr ni "sudo nix-env -iA nixpkgs."

alias x "xclip -selection clipboard"
abbr hms "home-manager switch"
abbr hme "chome-manager"
