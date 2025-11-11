{ config, pkgs, ... }:

{
  # Setup libwvirt with qemu
  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        # An UEFI implementation. Required for Win11
        # ovmf.enable = true;
        # ovmf.packages = [ pkgs.OVMFFull.fd ];

        # Allow software TPM emulation. Required for Win11
        swtpm.enable = true;
      };
    };

    # Allow non-root users to forward USB via Spice
    spiceUSBRedirection.enable = true;
  };

  # Nice UI to create and manage VMs.
  # BUT: quickemu works sufficiently well for my needs.
  # programs.virt-manager.enable = true;

  # This makes the host qemu the default controlled host in virtsh
  # For virt-manager: it will complain at startup and tell you how to fix it using its GUI
  # environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];

  environment.systemPackages = with pkgs; [
    # Installs the windows virtio iso required when installing windows. Only needed if
    # you build your own VM
    # win-virtio

    # A nice tool to simplify VM creation
    quickemu

    # For SPICE support. Allows clipboard sharing, USB forwarding, better display, ...
    spice-gtk
  ];
}
