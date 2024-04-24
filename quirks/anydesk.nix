{ config, pkgs, ... }:

{
  # Create an overlay for this package. Quite often, nix-wrapped proprietary packages break because download urls have changed.
  # Use this example to override the source. Refer to the official package definition and replicate the parts to override in here.
  nixpkgs.overlays = [
    (final: prev: {
      anydesk = prev.anydesk.overrideAttrs (oldAttrs: rec {
        version = "6.3.2";
        src = prev.fetchurl {
          urls = [
            "https://download.anydesk.com/linux/anydesk-${version}-amd64.tar.gz"
            "https://download.anydesk.com/linux/generic-linux/anydesk-${version}-amd64.tar.gz"
          ];
          # Will be wrong in the next version. Nix will complain and print the correct hash to use.
          hash = "sha256-nSY4qHRsEvQk4M3JDHalAk3C6Y21WlfDQ2Gpp6/jjMs=";
        };
      });
    })
  ];

  # Installed as part of programs/desktop.nix
  # environment.systemPackages = with pkgs; [ anydesk ];
}
