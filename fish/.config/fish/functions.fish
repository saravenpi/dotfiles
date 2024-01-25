# quick open a project with zoxide
function o
    set cur (pwd)
    z $argv
    nvim
    cd $cur
end

# saves the current path for quick access
function setp
    echo (pwd) >~/.project
end

# goes to the saved project path
function gop
    cd (cat ~/.project)
end

function z
    path = (zoxide query $argv)
    if test -z $path
        echo "No such project"
    else
        cd $path
    end
end
# init a c project quickly with kettle
function cinit
    kettle use c_project .
    echo "Project Initialised ✅"
end

function a
    set file (fzf)
    nvim $file
end

function batdiff
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end

function gss
    echo "Untracked files:"
    git status --porcelain | grep '^??' | wc -l
    echo "Staged files:"
    git status --porcelain | grep '^[ MD]' | wc -l
    echo "Lines of code:"
    tokei --output yaml | yq '.Total.code'
end

function gcs
    git clone "git@github.com:$argv.git"
end
