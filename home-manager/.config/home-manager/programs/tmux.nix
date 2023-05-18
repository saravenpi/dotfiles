{ config, pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        mouse = true;
        terminal = "screen";
        shortcut = "a";
        plugins = with pkgs; [
            {
                plugin = tmuxPlugins.dracula;
            }
        ];
    };
}
