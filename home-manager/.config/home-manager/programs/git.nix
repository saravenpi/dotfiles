{ config, pkgs, ... }:
{
    programs.git = {
        enable = true;
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
}
