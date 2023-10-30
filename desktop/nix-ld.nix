{ config, lib, pkgs, ... }:

let
  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master") { };
in {
  # Handy tool to find the library dependencies of a binary.
  # Call `nix-alien-find-libs myapp` to get the list of deps.
  environment.systemPackages = with nix-alien-pkgs; [ nix-alien ];

  # Prebuild tools are used in many dev environemnts. For example,
  # electron delivered via npm. To make these work in NixOS, find
  # their dependencies and add them here. Use
  # `nix-alien-find-libs ./executable` to get the list.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    ###########################################################################
    # There are a lot of common libraries. The following list basically is the
    # set of libs needed in a common Linux graphical desktop.

    stdenv.cc.cc.lib # standard compiler env/libs

    # X and related
    xorg.libxshmfence
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXrender
    xorg.libXinerama
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libXext
    libxkbcommon
    fontconfig.lib
    freetype

    # Graphics
    vulkan-loader.out # Does not work with NVIDIA - FIx?
    mesa
    mesa.drivers
    libdrm
    libglvnd
    libGL

    # Audio
    alsa-lib

    # GTK and Gnome environments
    gtk3
    libnotify
    glib
    gdk-pixbuf
    at-spi2-atk
    cairo
    pango

    # Other, common libs
    nss
    dbus.lib
    cups.lib
    expat
    zlib
    nspr
  ];
}
