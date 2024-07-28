{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        gitignore.follows = "gitignore";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
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

  outputs = { self, flake-utils, git-hooks, nixpkgs,...  }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let 
          pkgs = nixpkgs.legacyPackages.${system};
          pre-commit-check = import ./nix/pre-commit-check.nix { inherit pkgs git-hooks system; };
        in
        with pkgs;
        {
          checks = {
            inherit pre-commit-check;
          };

          devShells = {
            default = callPackage ./nix/shell.nix {};

            install-hooks = mkShell.override { stdenv = stdenvNoCC; } {
              inherit system;
              shellHook =
              let
                inherit (pre-commit-check) shellHook;
              in
              ''
                ${shellHook}
                echo Done!
                exit
              '';
            };
        };

        formatter = nixfmt-rfc-style;
      });
}


