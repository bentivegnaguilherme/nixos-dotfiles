# Copy to <project>/flake.nix, then: echo "use flake" > .envrc && direnv allow
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          jdk # Java toolchain, project-pinned
          jdtls # Java LSP for LazyVim
          gradle
          maven
        ];
      };
    };
}
