{ config, pkgs, ... }:
{
  home.username = "saravenpi";
  home.homeDirectory = "/home/saravenpi";

  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    # Terminal Apps
    bat
    tree
    exa
    zoxide
    htop
    tokei
    ranger
    neofetch
    tmux
    gum
    git
    neovim
    lynx
    vhs
    pfetch
    starship
    fish
    xorg.xmodmap

    # Desktop Apps
    insomnia
    spotify
    discord
    dbeaver
    virtualbox
    renoise
    tdesktop
    brasero

    # Fun
    lolcat
    cowsay
    asciiquarium

    # Programming
    nodejs
    yarn
    cargo
    rustc
    go
    python39
  ];

  home.sessionVariables = {
     EDITOR = "nvim";
  };

  imports = [
    ./programs/git.nix
    ./programs/starship.nix
    ./programs/tmux.nix
  ];
}
