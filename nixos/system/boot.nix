{
  boot = {
    # Initial RAM Disk Config
    initrd = {
      # Needed for unlocking /root
      availableKernelModules = ["usb_storage" "sdhci_pci"];
    };

    supportedFilesystems = ["btrfs"];

    # Number of Nix Configurations saved in /boot (and available to choose from during boot)
    loader.systemd-boot = {
      configurationLimit = 15;
    };

    kernelModules = [];
    extraModulePackages = [];
  };
}
