alias g git
alias nv nvim
alias c clear
alias l ls
alias q exit
alias hc "history clear"
alias gos "cd ~/code/.epita"
alias goo "cd ~/code/dreamit"
alias clp "gpaste-client"
alias clpc "gpaste-client delete-history"
function md
    pandoc $argv | w3m -T text/html
end

# opam configuration
source ~/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
set fish_greeting "Hey, Sara, what are we doing today ?"
