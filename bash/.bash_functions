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

s() {
    if [ "$#" -eq 0 ]; then
        # Get only active (running) tmux sessions
        sessions=$(tmux list-sessions 2>/dev/null | awk -F: '{print $1}')

        # If no active sessions, exit
        if [ -z "$sessions" ]; then
            echo "No active tmux sessions found."
            return 1
        fi

        # Let the user choose a session using gum
        session=$(echo "$sessions" | gum choose)

        # Attach to the selected session if it's not empty
        [ -n "$session" ] && tmux attach-session -t "$session"
    else
        tmux attach-session -t "$1"
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


killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port>"
    return 1
  fi

  PID=$(lsof -ti tcp:$1)

  if [ -z "$PID" ]; then
    echo "🔍 No process found on port $1"
  else
    kill -9 $PID && echo "💥 Port $1 freeed (PID $PID killed)"
  fi
}

