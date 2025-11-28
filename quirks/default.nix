{ config, pkgs, ... }:

{
  imports = [
    # Override some security errors
    ./permittedInsecurePackages.nix

    # Keep this and add specific fixes there that make Nix build again.
    ./buildFixes.nix
  ];
}
