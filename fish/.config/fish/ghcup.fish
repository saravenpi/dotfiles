# Check if '/home/saravenpi/.ghcup/bin' is in the PATH
if not contains /home/saravenpi/.ghcup/bin $PATH
    # Add '/home/saravenpi/.ghcup/bin' to the beginning of PATH
    set -gx PATH /home/saravenpi/.ghcup/bin $PATH
end

# Check if '$HOME/.cabal/bin' is in the PATH
if not contains $HOME/.cabal/bin $PATH
    # Add '$HOME/.cabal/bin' to the beginning of PATH
    set -gx PATH $HOME/.cabal/bin $PATH
end
