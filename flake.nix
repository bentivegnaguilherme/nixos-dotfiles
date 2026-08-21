{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    # Second, fresher channel for select packages that lag on stable
    # (currently: opencode). Import as `unstable.<pkg>` in home.nix.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
  };

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, noctalia, noctalia-greeter, ... }:
    let
      # To add a machine: create hosts/<name>/default.nix (with its
      # hardware.nix) and add `<name> = mkHost { hostname = "<name>"; };`
      # below. Pass `username` too if it differs from the default.
      # Rebuild with: sudo nixos-rebuild switch --flake ~/nixos-dotfiles#<name>
      unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
      mkHost = { hostname, username ? "gui" }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit noctalia hostname username unstable; };
          modules = [
            ./hosts/common.nix
            ./hosts/${hostname}
            noctalia-greeter.nixosModules.default
            home-manager.nixosModules.home-manager
          ];
        };
    in
    {
      nixosConfigurations = {
        archlinux = mkHost { hostname = "archlinux"; };
        # machine2 = mkHost { hostname = "machine2"; };
      };
    };
}
