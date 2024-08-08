{
  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      options = "caps:escape";
    };

    # Audio
    pipewire = {
      enable = true;
      audio.enable = true;
      jack.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    # Duh
    openssh.enable = true;

    # Enable touchpad support
    libinput.enable = true;
  };
}
