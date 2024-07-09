{ config, lib, pkgs, ... }:

{
  # Tailscale VPN
  services.tailscale.enable = true;
}
