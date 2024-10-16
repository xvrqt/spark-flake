{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./nixos/hardware-configuration.nix
    # Include the Asahi Linux Options + Drivers
    ./apple-silicon-support
    # List of services to start
    ./nixos/services
    # Fonts to install
    ./nixos/fonts.nix
  ];

  # rust = {
  #   enable = true;
  #   flavor = "stable";
  # };

  # Enable the use of flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    #	hashedPassword = "$y$j9T$aclS.QcZOPfxXBn3pa7aN/$cjLpl6MrpmGmCzQRWQxLW9DEKxhOnWLPCqMSvFqUR.";
  };
  services.getty.autologinUser = "xvrqt";

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
  environment.systemPackages = [
    pkgs.vim
    pkgs.glslls
    pkgs.glsl_analyzer
    pkgs.glslviewer
    pkgs.waypipe
  ];

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
