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
