{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Security Settings
  #

  # Allow wheel group members to use sudo without password
  security.sudo.wheelNeedsPassword = false;

  # Enable some policy kits
  security.rtkit.enable = true;

  #############################################################################
  # Polkit Settings
  #

  # PolKit allows to hand out privileges to programs. 
  # NOTE: see services.nix for polkit agent startup
  security.polkit.enable = true;
}
