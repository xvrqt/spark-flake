{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the Asahi Linux Options + Drivers
    #./apple-silicon-support
    # Additional NixOS Configs
    ./nixos
  ];

  # rust = {
  #   enable = true;
  #   flavor = "stable";
  # };

  # Enable the use of flakes
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      dates = "daily";
      options = "--delete-older-than 7d";
      automatic = true;
    };
    optimise = {
      dates = ["03:35"];
      automatic = true;
    };
  };

  # Impermanence
  # TODO: The persistent directory should be a variable that is used by
  # both fileSystems and persistence so it can never be mismatched
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      # Save program logs in case something goes wrong
      "/var/log"
      # Save Bluetooth Settings
      # TODO: Make Declarative
      "/var/lib/bluetooth"
      # Save UID/GUID assignments
      # TODO: Make Declarative (user already done)
      "/var/lib/nixos"
      # IWD Settings
      # TODO: Can this be done programmatically ?
      "/var/lib/iwd"

      # Save Coredumps in case something goes wrong
      "/var/lib/systemd/coredump"
    ];
    files = [
      # Save the Machine-ID between boots
      "/etc/machine-id"
    ];
    # TODO: The username should be a variable used in users.users so that
    # it can never be mismatched.
    users.xvrqt = {
      directories = [
        "Media"
        "Projects"
        "Documents"
        "Development"
        # TODO: Include this with the web bundle ?
        # Or check if installed ?
        ".librewolf"
        ".local/share/direnv"
        ".flake"
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".local/share/keyring";
          mode = "0700";
        }
      ];
      files = [
        ".config/hyfetch.json"
      ];
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  # Prevents us from needing to use impure evaluation
  # Normally loads from the EFI volume, but we copy it locally
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in TTY
  };

  # Enable our shell
  programs.zsh.enable = true;

  # Users
  users.mutableUsers = true;
  users.users.xvrqt = {
    # i.e. is *not* a daemon wearing human skin
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "xvrqt";

    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.

    # Only the essentials
    packages = with pkgs; [
      zsh
    ];
    hashedPassword = "$y$j9T$aclS.QcZOPfxXBn3pa7aN/$cjLpl6MrpmGmCzQRWQxLW9HDEKxhOnWLPCqMSvFqUR.";
  };
  services.getty.autologinUser = "xvrqt";
  services.usbmuxd.enable = true;
  programs = {
    ssh.startAgent = false;
    gnupg = {
      agent.enable = true;
      agent.enableSSHSupport = true;
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];
    rtkit.enable = true;
  };

  # Additional Packages
  environment = {
    shellInit = ''
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
    systemPackages = [
      pkgs.vim
      pkgs.glslls
      pkgs.glslviewer
      pkgs.glsl_analyzer
      pkgs.waypipe
      pkgs.brightnessctl
      pkgs.ifuse
      pkgs.libimobiledevice
      pkgs.gnupg
    ];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
