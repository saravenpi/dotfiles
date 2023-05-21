{ config, pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        mouse = true;
        terminal = "screen";
        shortcut = "a";
        baseIndex = 1;
        plugins = with pkgs; [
            {
                plugin = tmuxPlugins.catppuccin;
                extraConfig = "set -g @catppuccin_flavour 'latte'";
            }
            {
                plugin = tmuxPlugins.sidebar;
            }
        ];
        extraConfig = ''
            bind | split-window -h
            bind - split-window -v
            unbind '"'
            unbind %
            bind -n M-Left select-pane -L
            bind -n M-Right select-pane -R
            bind -n M-Up select-pane -U
            bind -n M-Down select-pane -D
            set -g status-position top
            set-option -g allow-rename off
        '';
    };
}
