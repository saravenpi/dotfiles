function o
    set cur (pwd)
    z $argv
    nvim
    cd $cur
end

function setp
    echo (pwd) > ~/.project
end

function gop
    cd (cat ~/.project)
end

function cinit
    kettle use c_project project &> /dev/null
    mv project/* .
    rm -rf project
    echo "Project Initialised ✅"
end

function a
    set file (fzf)
    nvim $file
end
