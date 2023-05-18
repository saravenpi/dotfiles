{ config, pkgs, ... }:

{
  home.username = "saravenpi";
  home.homeDirectory = "/home/saravenpi";

  home.stateVersion = "22.11";
  home.packages = [
    pkgs.bat
    pkgs.exa
    pkgs.zoxide
    pkgs.htop
    pkgs.tokei
    pkgs.ranger
    pkgs.neofetch
    pkgs.tmux
    pkgs.neovim
    pkgs.gum
    pkgs.yarn
    pkgs.git


    pkgs.insomnia
    pkgs.spotify
    pkgs.discord
    pkgs.alacritty


    pkgs.nodejs
    pkgs.cargo
    pkgs.rustc
    pkgs.go
    pkgs.python39
    pkgs.ncurses
    pkgs.mesa
    pkgs.libGLU
    pkgs.glew
    pkgs.freeglut

    pkgs.pfetch
    pkgs.starship
    pkgs.fish
    pkgs.zsh
  ];

  home.sessionVariables = {
     EDITOR = "nvim";
  };

  programs.home-manager.enable = false;

  programs.git = {
      userName = "Saravenpi";
      userEmail = "saravenpi@tuta.io";
      extraConfig = {
          core = {
              editor = "nvim";
          };
          color = {
              ui = true;
          };
          push = {
              default = "simple";
          };
          pull = {
              ff = "only";
          };
          init = {
              defaultBranch = "main";
          };
      };
  };

  imports = [
    ./programs/git.nix
    ./programs/starship.nix
    ./programs/tmux.nix
  ];

  home.keyboard = {
      layout = "us";
      variant = "intl";
  };
}
