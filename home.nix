{pkgs, ...}: let
  user = "xvrqt";
in {
  imports = [
    # EWWW Configuration
    ./home/eww
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # Enable our shell
    zsh.enable = true;
    direnv.enable = true;

    termusic.enable = false; # not building

    # Shell

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

  home = {
    # User Setup
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "24.05"; # Please read the comment before changing.

    packages = [
    ];

    # file = {
    #   ".config/alacritty/theme.yml".source = ./themes/catppuccin-mocha.yml;
    # };
    sessionVariables = {};
  };

  # Window Manager
  desktops.niri = {
    enable = true;
    monitor = "mac-book-pro";
  };
}
