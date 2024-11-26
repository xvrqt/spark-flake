let
  ##################
  # LUKS Partition #
  ##################
  # There is only one device (nvme0n1) and we only use two partitions on it: 2 (root) and 4 (boot)
  # This is nvme0n1p2 (root) encrypted with LUKs v1
  # It must be decrupted before scanning for LVM
  ENCRYPTED_PARTITION = "/dev/disk/by-uuid/2cded785-e8d1-45f0-8da2-43669075e0f4";

  ###################
  # Logical Volumes #
  ###################
  # Unencrypted nvme0n1p2 reveals and LVM setup with two Volumes
  # SWAP is 17GiB to allow suspend/hibernate (and building huge packages lmao)
  SWAP_LV = "/dev/disk/by-uuid/a95e2b98-61be-479c-916c-37d41ecc27e7";
  # ROOT is the rest of the disk (~473GiB) which has BTRFS installed on it
  #### The BTRFS has 3 sub-volumes on it: root, nix, and persist
  #### Root is where '/' is mounted and is wiped on every restart
  #### Nix is where '/nix' is mounted, and is persisted between boots (not that it needs to be)
  #### Persist is mounted at '/persist' and is where files mapped with the Impermanence module are linked
  #### so that they may be persisted through reboots. Anything not mapped will be wiped between boots.
  ROOT_LV = "/dev/disk/by-uuid/1cfde13c-6e84-4b4b-861a-86193c791eb6";

  ########
  # BOOT #
  ########
  # Boot partition device UUID
  # 512MiB VFAT partition: nvme0n1p4
  BOOT_PARTITION = "/dev/disk/by-uuid/83E6-1413";
in {
  # Unlock the encrypted partition on boot
  boot.initrd = {
    # Mounted the decrypted partition to /dev/mapper/encrypted
    luks.devices.encrypted = {
      device = ENCRYPTED_PARTITION;
      # Decrypt the partition, _then_ scan for logical volumes
      preLVM = true;
    };
  };
  # Set swap device to use /dev/lvm/swap
  swapDevices = [
    {
      device = SWAP_LV;
    }
  ];
  # Configure /dev/lvm/root LV with BTRFS
  fileSystems = {
    "/" = {
      device = ROOT_LV;
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/nix" = {
      device = ROOT_LV;
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/persist" = {
      device = ROOT_LV;
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    # Configure /dev/nvme0n1p4 as the boot partition
    "/boot" = {
      device = BOOT_PARTITION;
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    #########################
    # NETWORKED FILESYSTEMS #
    #########################
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
}
