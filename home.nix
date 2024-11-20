{pkgs, ...}: let
  user = "xvrqt";
in {
  imports = [
    # EWWW Configuration
    ./home/eww
  ];

  # Home Manager Settings
  home = {
    # User Setup
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "24.05"; # Please read the comment before changing.
  };

  # Window Manager
  desktops.niri = {
    # enable = true;
    monitor = "mac-book-pro";
  };

  services = {
    gpg-agent = {
      enableSshSupport = true;
      enable = true;
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # Enable our shell
    zsh.enable = true;
    direnv.enable = true;

    termusic.enable = false; # not building

    gpg = {
      enable = true;
    };

    # Browser
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
      };
    };
    neovim.plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
    rofi.enable = true;
    rofi.package = pkgs.rofi-wayland;
  };
}
