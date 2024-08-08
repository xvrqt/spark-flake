# Rust Programming Language
{
  pkgs,
  inputs,
  ...
}: let
  # rust-stable = pkgs.rust-bin.stable.latest.default;
  # rust-minimal = pkgs.rust-bin.stable.latest.minimal;
  rust-nightly = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  rust-package = rust-nightly;
in {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  environment.systemPackages = [rust-package];
}
