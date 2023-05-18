{ config, pkgs, ... }:
{
    programs.git = {
        enable = true;
        userEmail = "saravenpi@tuta.io";
        userName = "Saravenpi";
    };
}
