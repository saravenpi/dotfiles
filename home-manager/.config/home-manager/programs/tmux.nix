{ config, pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        mouse = true;
        keyMode = "vi";
        terminal = "screen";
        shortcut = "a";
        plugins = with pkgs; [
            {
                plugin = tmuxPlugins.battery;
                extraConfig = "set -g status-right '#{battery_status_bg} Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %a %h-%d %H:%M '";
            }
        ];
    };
}
