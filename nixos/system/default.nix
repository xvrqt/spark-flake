{
  imports = [
    # How to boot, and what to do while booting
    ./boot.nix
    # Setup network interfaces, wireless, and import known networks
    ./networking.nix
    # File system structure
    ./file-systems.nix
    # Hardware drivers
    ./hardware-configuration.nix
  ];
}
