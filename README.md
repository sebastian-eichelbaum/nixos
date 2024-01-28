# NixOS

Personal NixOS configuration for work and pleasure. This configuration does not use home-manager nor flakes.

This creates a minimal encrypted dev machine, using X+AwesomeWM for windowing; neovim, zsh and devbox for coding/working.

Works well with my dotfiles: https://github.com/sebastian-eichelbaum/dotfiles

## NixOS Installation

### Disk Setup

The first step is to create the needed partitions. After physical creation, encrypt and format them.

- Use gparted to create the disk layout.
  - Remember to add an "ESP" partion. Set the flag "esp". This is the EFI boot partition
  - Assumed here: /dev/nvme0n1p1 is ESP, nvme0n1p2 is root, nvme0n1p3 is home
- Check encryption performance:
  - `cryptsetup benchmark`
  - Find the algorithm and key length that performs best. Usually aes-xts, 256bit Key.
  - Before choosing something wrong, check about key-size doubling. Call `cryptsetup --help` to get a
    list of defaults. They will probably be the best option.
- Create and encrypt root:
  ```sh
  cryptsetup luksFormat /dev/nvme0n1p2
  cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
  mkfs.ext4 -L root /dev/mapper/cryptroot
  ```
- Create and encrypt home:
  > **Warning**: if you re-use an existing home, keep it as is.
  ```sh
  cryptsetup luksFormat /dev/nvme0n1p3
  cryptsetup luksOpen /dev/nvme0n1p3 crypthome
  mkfs.ext4 -L home /dev/mapper/crypthome
  ```

### Mount

Create the actual layout of '/' to be used by NixOS. Mount the disks accordingaly - i.e. root, home, boot.

> **Note:** This setup uses the ESP partition as boot partition. This is the default behaviour of NixOS. It stores kernels and initrd there.

- If not yet done, open the encrypted root/home disks via cryptsetup luksOpen.
- Mount the disks as required:
  ```sh
  mkdir -p /mnt
  mount /dev/disk/by-label/root /mnt
  mkdir -p /mnt/boot
  mount /dev/disk/by-label/ESP /mnt/boot
  mkdir -p /mnt/home
  mount /dev/disk/by-label/home /mnt/home
  ```

### NixOS Configuration

NixOS has a handy tool to generate a default config. As this repo contains a NixOS configuration already,
the created config is only relevant for its hardware configuration.

- Generate the machine configuration
  ```sh
  mkdir -p /etc
  cd /etc
  git clone git@github.com:sebastian-eichelbaum/nixos.git
  cd nixos
  nixos-generate-config --root /mnt --show-hardware-config > hardware-configuration.nix
  # Choose one of the predefined system setups in hosts. Link or copy:
  ln -s machines/something.nix machine.nix
  # Edit machine.nix and make sure the filesystems match the ones in the generated
  # hardware-configuration.nix. Also check: Kernel Modules, Hostname, ...
  # After stealing the relevant parts from hardware-configuration.nix, delete. It is
  # not needed anymore.
  rm hardware-configuration.nix
  ```
- Generate the user configuration. This NixOs configuration creates root and a single, additonal user called "seb". The users are locked. passwd will not work. To set the user passwords:
  - Create password hashes: `mkpasswd`
  - Edit /etc/nixos/users.nix:
    ```nix
    # User password configuration.
    { config, ... }:
    {
        # Use mkpasswd.
        users.users."seb".hashedPassword = "abcd";
        users.users."root".hashedPassword = "efgh";
    }
    ```
- Configure the selection of programs.
  - Create `programs.nix` - it imports everything you want to install
  - Edit /etc/nixos/programs.nix:
    ```nix
    { config, pkgs, ... }:
    {
        imports = [
            # Install everything
            ./programs

            # ... or select:
            ./programs/cli.nix
            # ...
        ];

        # Add machine specific things here
        environment.systemPackages = with pkgs; [ ];
    }
    ```

### NixOS Installation

- (Optional but recommended) Update to the unstable channel before install
  - `nix-channel --add https://nixos.org/channels/nixos-unstable nixos`
- `nixos-install`
