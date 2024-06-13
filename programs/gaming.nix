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

  #############################################################################
  # Gamescope support
  #

  # Has issues with NVIDIA drivers. Disabled for now.

  # Gamescope is a tiny compositor to run games in, allowing to spoof
  # resolutions and limit FPS for games that do not support that.
  # programs.gamescope.enable = true;
  # programs.gamescope.capSysNice = true;
}
