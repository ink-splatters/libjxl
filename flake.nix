{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://aarch64-darwin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
    ];
  };

  outputs = { self, flake-utils,  nixpkgs,...  }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let 
          pkgs = nixpkgs.legacyPackages.${system};
        in
        with pkgs;
        {
          checks = {
            inherit pre-commit-check;
          };

          devShells = {
            default = callPackage ./nix/shell.nix {};
        };

        formatter = nixfmt-rfc-style;
      });
}


