{ config, lib, pkgs, ... }:

{
  # To sum up the current NVidia driver situation: a buggy mess. This script tries to circumvent those issues.

  # NixOS enables the fbdev feature on later drivers. This breaks drm - it does not send updates on connected
  # displays anymore -> rendering autorandr useless.
  hardware.nvidia.modesetting.enable = lib.mkForce false;

  # Instead, enable modesetting but disable fbdev.
  boot.kernelParams =
    lib.mkAfter [ "nvidia_drm.fbdev=0" "nvidia-drm.modeset=1" ];
}
