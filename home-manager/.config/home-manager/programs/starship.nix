{ config, pkgs, ... }:

{
    programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
            line_break = {
                disabled = false;
            };

            add_newline = false;

            directory = {
                truncation_length = 3;
                truncation_symbol = "📁";
            };

            time = {
                disabled = false;
                time_format = "%R";
                format = " $time ";
            };

            battery = {
                charging_symbol = "🔌 ";
                discharging_symbol = "⚡️ ";
                full_symbol = "🔋 ";
            };
        };
    };
}
