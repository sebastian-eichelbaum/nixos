{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Pulse + PipreWire
  #

  # Do not use sound.enable. This causes issues with pipewire.Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Disable Pulse as it is now superceeded by PipeWire
  hardware.pulseaudio.enable = false;

  # Optional but recommended for PipeWire
  security.rtkit.enable = true;

  # Setup PipeWire.
  services.pipewire = {
    enable = true;

    # Use Alsa and Pulse compatible interfaces
    alsa.enable = true;
    pulse.enable = true;

    # Legacy stuff: old games maybe?
    alsa.support32Bit = false;
  };

  # Pavucontrol to manage audio
  environment.systemPackages = with pkgs; [
    # Control audio
    pavucontrol

    # For alsamixer and other alsa tools
    alsa-utils
  ];

  #############################################################################
  # Quirks and Hacks
  #

  # Get rid of the annoying pc speaker (if any)
  boot.blacklistedKernelModules = [ "pcspkr" "snd_pcsp" ];
}
