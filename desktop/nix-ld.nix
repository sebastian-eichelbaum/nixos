{ config, lib, pkgs, ... }:

#############################################################################
# Nixify: how to make binaries work in NixOS?
#
# It is a quite common scenario: you pip, npm, ... install a package that
# comes with a generic pre-compiled binary. These binaries rely on the
# Filesystem Hierarchy Standard (FHS). NixOS does provide that.
#
# To be able to run binaries on NixOS, there are several options. There
# is a nice overview on StackOverflow:
#
# https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos
#
#
# This nix module sets up nix-ld and steam-run to solve the issue:
#  * nix-ld: It manages linked libraries to be used for binaries. It sets
#            LD_LIBRARY_PATH so that binaries find all libs they need. It
#            needs to be configured to know which libs should be made
#            available. (lightweight)
#  * steam-run: a very handy tool to execute a binary in a steam runtime
#               environment - just like a game. Ideal to run Unity binaries
#               for example. Requires steam to be installed. (heavyweight but
#               works nearly always)
#
#
# On top of that, it provides a tiny helper script "nixify" that combines
# the NixOS OpenGL/Vulkan/OpenCL lib location with nix-ld. Most of the time,
# nix-ld does everything behind the scenes. If not, nixify can help.
let
  # Tiny tool to set LD_LIBRARY_PATH and run the specified command
  nixify = pkgs.writeShellScriptBin "nixify" ''
    LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH:/run/current-system/sw/share/nix-ld/lib
    echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
    exec "$@"
  '';
in {
  # Install some tools
  environment.systemPackages = [
    # Call "nixify some commands" to run it in the nix-ld and opengl environment
    nixify

    # Requires steam
    pkgs.steam-run
  ];

  # Prebuild tools are used in many dev environemnts. For example,
  # electron delivered via npm. To make these work in NixOS, find
  # their dependencies and add them here. To get the list of libs, use:
  #
  # nix run github:thiagokokada/nix-alien -- ~/myapp
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
    xorg.libXxf86vm
    xorg.libXcursor
    xorg.libXScrnSaver
    xorg.libXi
    xorg.libXtst
    xorg.libxkbfile
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
    # vulkan-loader

    # Audio
    alsa-lib
    #libpulseaudio
    #pipewire

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
    icu
    openssl
    curl
    nspr

    systemdLibs # udev and others

    #fuse3
    #libunwind
    #libusb1
    #libuuid
    #libxml2

  ];

}
