{
  description = "Python dev environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python312;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
            python.pkgs.pip
            python.pkgs.setuptools
            python.pkgs.wheel
          ];

          shellHook = ''
            echo "Python $(python --version) — pip install away"
            echo "Use 'python -m venv .venv && source .venv/bin/activate' for a venv"
          '';
        };
      });
}
