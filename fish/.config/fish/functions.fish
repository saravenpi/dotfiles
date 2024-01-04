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

# init a c project quickly with kettle
function cinit
    kettle use c_project project &>/dev/null
    mv project/* .
    rm -rf project
    echo "Project Initialised ✅"
end

function a
    set file (fzf)
    nvim $file
end

function batdiff
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end
