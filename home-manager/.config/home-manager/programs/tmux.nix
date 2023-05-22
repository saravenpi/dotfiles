{ config, pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        mouse = true;
        terminal = "screen";
        shortcut = "a";
        baseIndex = 1;

        extraConfig = ''
            unbind '"'
            unbind %
            bind | split-window -h
            bind - split-window -v
            bind -n M-Left select-pane -L
            bind -n M-Right select-pane -R
            bind -n M-Up select-pane -U
            bind -n M-Down select-pane -D

            set-option -g allow-rename off

            set -g status-position top
            set -g pane-border-status top
            set -g pane-border-format '#[bold]#{pane_title}#[default]'

            set-window-option -g window-status-format "#[fg=black,bg=yellow] #I #[fg=white,bg=#141414] #{b:pane_current_path} "
            set-window-option -g window-status-current-format "#[fg=black,bg=orange] #I #[fg=white,bg=#141414] #{b:pane_current_path} "

            set -g status-style bg=#1a1a1a,fg=white
            set -g window-status-style bg=yellow
            set -g window-status-current-style bg=orange,fg=white

            set -g @prefix_highlight_fg 'white'
            set -g @prefix_highlight_bg 'orange'

            set -g status-right '%H:%M | 🌵'
        '';
    };
}
