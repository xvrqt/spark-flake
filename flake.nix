{
  description = "NixOS configuration";

  inputs = {
    # Essentials
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # My Flakes
    cli.url = "github:xvrqt/cli-flake";
    niri.url = "github:xvrqt/niri-flake";

    # 3rd Party Flakes
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf/v0.7";
  };

  outputs = {
    cli,
    nvf,
    niri,
    nixpkgs,
    home-manager,
    rust-overlay,
    ...
  } @ inputs: let
    system = "aarch64-linux";
    machine = "spark";
  in {
    nixosConfigurations.${machine} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs machine;};
      modules = [
        # Window Manager
        niri.nixosModules.default
        # Rust
        ({pkgs, ...}: {
          nixpkgs.overlays = [rust-overlay.overlays.default];
          environment.systemPackages = [pkgs.wasm-pack ((pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml).override {extensions = ["rust-src"];})];
        })
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
                cli.homeManagerModules.default
                # Window Manager
                niri.homeManagerModules.${machine}
                # Highly Customized NeoVim
                nvf.homeManagerModules.default
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
