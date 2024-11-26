{
  description = "NixOS configuration";

  inputs = {
    # Essentials
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    # My Flakes
    rust.url = "github:xvrqt/rust-flake";
    niri.url = "github:xvrqt/niri-flake";
    #terminal.url = "github:xvrqt/terminal-flake";
    terminal.url = "/home/xvrqt/Development/terminal-flake";
  };

  outputs = {
    rust,
    niri,
    nixpkgs,
    terminal,
    impermanence,
    home-manager,
    apple-silicon,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    system = "aarch64-linux";
    machine = "spark";
  in {
    nixosConfigurations.${machine} = nixpkgs.lib.nixosSystem {
      inherit pkgs system;
      specialArgs = {inherit inputs machine;};
      modules = [
        # Window Manager
        niri.nixosModules.default
        # Rust Programming Language Toolchain
        rust.nixosModules.default
        # Opt-In Persistence per Directory/File
        impermanence.nixosModules.default
        # Asahi Hardware Support
        apple-silicon.nixosModules.apple-silicon-support
        # Main NixOS Module - pulls in sub-modules in ./nixos
        ./spark.nix
        # Home Manager as a NixOS Modules (contains sub-modules)
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = {inherit inputs machine;};
            useGlobalPkgs = true;
            useUserPackages = true;
            users.xvrqt = {...}: {
              imports = [
                # Shell Customization & Useful Command Programs
                terminal.homeManagerModules.${system}.default
                # Window Manager
                niri.homeManagerModules.${machine}
                # Main Home Manager Module - pulls in sub-modules from ./home
                ./home.nix
              ];
            };
          };
        }
      ];
    };
  };
}
