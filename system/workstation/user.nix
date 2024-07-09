# #############################################################################
# User Setup
#

{ config, pkgs, ... }:

{
  # Add some extra groups that are relevant for workstations
  users = {
    users = {
      "${config.SysConfig.user.name}" = {
        extraGroups = [
          # The usual "make the PC actually configurable"-groups:
          "networkmanager"
          "audio"
          "video"
          "plugdev"
          "input"

          # Allow virtualization
          "libvirtd"
          "vboxusers"
        ];
      };
    };
  };
}
