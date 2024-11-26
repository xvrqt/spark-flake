{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=1h
  '';

  # Apple-Silicon Platform
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot = {
    initrd = {
      availableKernelModules = ["usb_storage" "sdhci_pci"];
      kernelModules = [];
      luks.devices.encrypted = {
        device = "/dev/disk/by-uuid/2cded785-e8d1-45f0-8da2-43669075e0f4";
        preLVM = true;
      };
    };
    supportedFilesystems = ["btrfs"];
    kernelModules = [];
    extraModulePackages = [];
    loader.systemd-boot = {
      configurationLimit = 15;
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/a95e2b98-61be-479c-916c-37d41ecc27e7";
    }
  ];

  #boot.resumeDevice = "/swapfile";
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1cfde13c-6e84-4b4b-861a-86193c791eb6";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/1cfde13c-6e84-4b4b-861a-86193c791eb6";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/1cfde13c-6e84-4b4b-861a-86193c791eb6";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
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
