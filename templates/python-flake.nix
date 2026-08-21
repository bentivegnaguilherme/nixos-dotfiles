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
          (python3.withPackages (ps: with ps; [
            pip
          ]))
          uv # fast venv + dependency manager
          pyright # Python LSP for LazyVim
        ];

        env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc ]; # for compiled wheels
      };
    };
}
