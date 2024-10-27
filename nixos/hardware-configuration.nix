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
    loader.systemd-boot = {
      configurationLimit = 10;
    };
  };

  fileSystems = {
    "/" = {
      # nvme0n1p5 (169GiB)
      device = "/dev/disk/by-uuid/c09ffd36-d0e1-451e-9604-18d574e1e284";
      fsType = "ext4";
      options = ["noatime"];
    };

    # nvme0n1-2 (280GiB)
    "/home/xvrqt" = {
      #      depends = ["/"];
      device = "/dev/disk/by-uuid/185a51f1-5867-4027-b578-8aec5b09c33e";
      fsType = "ext4";
      #      options = ["bind"];
    };

    # nvme0n1p5 (476MiB)
    "/boot" = {
      device = "/dev/disk/by-uuid/83E6-1413";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    # Mounted when connected to home network
    "/imports/music" = {
      device = "192.168.1.6:/zpools/hdd/media/music";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };

    "/imports/images" = {
      device = "192.168.1.6:/zpools/hdd/media/images";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };

    "/imports/movies" = {
      device = "192.168.1.6:/zpools/hdd/media/movies";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };

    "/imports/series" = {
      device = "192.168.1.6:/zpools/hdd/media/series";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };

    "/imports/videos" = {
      device = "192.168.1.6:/zpools/hdd/media/videos";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };

    "/imports/xvrqt" = {
      device = "192.168.1.6:/zpools/ssd/xvrqt";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
    };
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
