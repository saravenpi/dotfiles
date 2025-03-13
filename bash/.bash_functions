# goes to the saved project path
gop() {
	tmppath=$(cat ~/.project)
	cd $tmppath
	unset tmppath
}

# saves the current path for quick access
setp() {
	echo $(pwd) >~/.project
}

# quick cd with zoxide
z() {
	local args=("$@")
	tmppath=$(zoxide query $args)
	echo $tmppath
	if [[ -z $tmppath ]]; then
		echo "No such project"
	else
		cd $tmppath
	fi
	unset tmppath
}

# zoxide to the path and opens it with nvimgp
grp() {
	z $1
	nvim .
}

# quick open a project with zoxide
o() {
    local args=("$@")
    local cur=$(pwd)

    if [[ -z "$args" || "$args" == "." ]]; then
        ts "$cur"
    else
        z "${args[@]}"
        ts "${args[@]}"
    fi

    cd "$cur"
    unset cur
}

op() {
  tmppath=$(cat ~/.project)
	cd $tmppath
  ts $tmppath
	unset tmppath
}

oe() {
	cur=$(pwd)
	z $1
	epi $1
	cd $cur
	unset cur
}

gss() {
	echo "Untracked files:"
	git status --porcelain | grep '^??' | wc -l
	echo "Staged files:"
	git status --porcelain | grep '^[ MD]' | wc -l
	echo "Lines of code:"
	tokei --output yaml | yq '.Total.code'
}

gcs() {
	git clone "git@github.com:$1.git"
}

ta() {
	if [ "$#" -eq 0 ]; then
		sessions=$(tmux list-sessions -F "#{session_name}")
		session=$(gum choose $sessions)
		tmux a -t $session
	else
		tmux a -t $1
	fi
}

welcome() {
	# pokemon-colorscripts -n shaymin --no-title
	# cal
	echo "👋 Salut ! :D"
	# bun run $HOME/code/blagues/index.ts
	# echo "🧠 Pense à checker ~/notes/ (wk)"
	# echo "📅 Aujourd'hui c'est: $(date)"
	# echo "🔥 Streaks: "
	# streaks
}
