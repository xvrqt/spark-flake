{
  imports = [
    # Hardware drivers
    ./hardware-configuration.nix
    # Setup network interfaces, wireless, and import known networks
    ./networking.nix
  ];
}
