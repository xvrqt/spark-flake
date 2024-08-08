{pkgs, ...}: let
  user = "xvrqt";
in {
  imports = [
    # NeoVim Customization
    ./home/nvf.nix
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Shell
    zsh.enable = true;

    # Terminal Emulator
    alacritty.enable = true;

    # Browser
    librewolf.enable = true;
  };

  home = {
    # User Setup
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "24.05"; # Please read the comment before changing.

    file = {};
    sessionVariables = {};
  };

  # Window Manager
  desktops.niri = {
    enable = true;
    monitor = "mac-book-pro";
  };
}
