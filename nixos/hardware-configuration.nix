{
  lib,
  pkgs,
  machine,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Apple-Silicon Platform
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot = {
    initrd = {
      availableKernelModules = ["usb_storage" "sdhci_pci"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c09ffd36-d0e1-451e-9604-18d574e1e284";
    fsType = "ext4";
  };

  #  fileSystems."/p2" = {
  #    device = "/dev/disk/by-uuid/27c2bc00-7fd6-4ca4-85d9-242bab0bf6f6";
  #    fsType = "ext4";
  #  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/83E6-1413";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # Networking
  networking = {
    nameservers = ["1.1.1.1" "9.9.9.9"];
    hostName = machine; # "Spark"
    # Enable WiFi but use iwd instead of wpa_supplicant for Mac Compatibility
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    interfaces = {
      wlan0 = {useDHCP = lib.mkDefault true;};
    };

    # Automatically connect to known networks
    wireless.iwd = {
      enable = true;
      settings = {
        General.EnableNetworkConfiguration = true;
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  swapDevices = [];

  hardware = {
    # We're using the Asahi Linux Mesa Drivers
    # opengl.enable = true;
    # opengl.package = pkgs.lib.mkForce pkgs.mesa-asahi-edge.drivers;
    asahi = {
      enable = true;
      withRust = true;
      setupAsahiSound = true;
      useExperimentalGPUDriver = true;
      # Rebuilds the world - but allows us to have a 'pure' eval
      experimentalGPUInstallMode = "overlay";
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    blueman.enable = true;
  };
}
