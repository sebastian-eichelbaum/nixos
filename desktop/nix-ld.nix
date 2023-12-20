{ config, lib, pkgs, ... }:

#############################################################################
# Nix-ld: If you want to use binaries that are not "nixified"
#
#
# Binaries, either closed source or binaries delivered via another packaging
# tool like pip, npm, ... search their libs somewhere in /usr/lib - the usual
# way in most Linux. This does not exist in NixOS.
#
# Libs: Nix-ld can create a dir for us and link the libs from packages in
#       there. This file defines some very common libs usually used in
#       desktop environemnts - X, alsa, ...
#
# GPU: NixOS created a dir /run/opengl-driver/lib for us that contains the
#      hardware specific OpenGL, Vulkan, Cuda, OpenCL, ... libs/drivers. It
#      does not contain the mesa stuff (libGL)
#

# Most of the time, nix-ld does everything behind the scenes. If not, call
# your program with a defined LD_LIBRARY_PATH:
#
# LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/current-system/sw/share/nix-ld/lib
# The tool "nixify" does that for you.

let
  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master") { };

  # Tiny tool to set LD_LIBRARY_PATH and run the specified command
  nixify = pkgs.writeShellScriptBin "nixify" ''
    LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH:/run/current-system/sw/share/nix-ld/lib
    echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
    exec "$@"
  '';
in {
  # Install some tools
  environment.systemPackages = [
    # Handy tool to find the library dependencies of a binary.
    # Call `nix-alien-find-libs myapp` to get the list of deps.
    nix-alien-pkgs.nix-alien

    # Call "nixify some commands" to run it in the nix-ld and opengl environment
    nixify
  ];

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
    # List the non-hardware dependent libs here. I.e. mesa. Do not list vulkan
    # or cuda/opencl things here
    mesa
    libdrm
    libglvnd
    libGL
    # SHould be in /run/opengl-driver/lib already?!
    # mesa.drivers

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
