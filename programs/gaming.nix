{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Games and emulators
  #

  # Games and emulators
  environment.systemPackages = with pkgs;
    [
      # Game launchers and stores
      steam
      # lutris
      # heroic

      # Emulation
      # yuzu-mainline

      # VR
      # sidequest
    ];

  #############################################################################
  # Gamemode support
  #

  # Unlike its name, it is not only useful for games.
  programs.gamemode.enable = true;
  programs.gamemode.enableRenice = true;
  programs.gamemode.settings = {
    general = { renice = 10; };
    # NOTE: those scripts can also be set in ~/.config/gamemode.ini
    custom = {
      start = ''
        ${pkgs.libnotify}/bin/notify-send -i applications-games "GameMode" "Started"
          ${pkgs.systemd}/bin/systemctl --user stop picom.service
      '';
      end = ''
        ${pkgs.libnotify}/bin/notify-send -i applications-games "GameMode" "Stopped"
          ${pkgs.systemd}/bin/systemctl --user start picom.service
      '';
    };

  };

}
