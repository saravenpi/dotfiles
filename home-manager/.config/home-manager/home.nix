{ config, pkgs, ... }:
{
  home.username = "saravenpi";
  home.homeDirectory = "/home/saravenpi";

  home.stateVersion = "22.11";
  home.packages = [
    # Terminal Apps
    pkgs.bat
    pkgs.tree
    pkgs.exa
    pkgs.zoxide
    pkgs.htop
    pkgs.tokei
    pkgs.ranger
    pkgs.neofetch
    pkgs.tmux
    pkgs.gum
    pkgs.git
    pkgs.neovim
    pkgs.lynx
    pkgs.vhs
    pkgs.pfetch
    pkgs.starship
    pkgs.fish
    pkgs.xorg.xmodmap

    # Desktop Apps
    pkgs.insomnia
    pkgs.spotify
    pkgs.discord
    pkgs.dbeaver
    pkgs.virtualbox
    pkgs.renoise
    pkgs.tdesktop
    pkgs.brasero

    # Fun
    pkgs.lolcat
    pkgs.cowsay
    pkgs.asciiquarium

    # Programming
    pkgs.nodejs
    pkgs.yarn
    pkgs.cargo
    pkgs.rustc
    pkgs.go
    pkgs.python39
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
