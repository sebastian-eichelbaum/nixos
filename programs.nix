{ config, pkgs, ... }:

{
  imports = [ ./programs ];

  # Add machine specific things here
  environment.systemPackages = with pkgs; [ ];
}
