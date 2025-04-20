{
  description = "Stechec2 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      stechec2 = pkgs.stdenv.mkDerivation {
        name = "stechec2";
        version = "2.0.0";
        src = ./.;
        propagatedBuildInputs = with pkgs; [
          cppzmq
          gflags
          libsodium
        ];
        nativeBuildInputs = with pkgs; [cmake];
      };
      stechec2-generator = pkgs.python3Packages.buildPythonPackage {
        name = "stechec2-generator";
        src = ./tools;
        pyproject = true;
        build-system = [
          pkgs.python3Packages.hatchling
        ];
        propagatedBuildInputs = with pkgs.python3Packages; [
          pyyaml
          jinja2
        ];
      };
      stechec2-run = pkgs.python3Packages.buildPythonApplication {
        name = "stechec2-run";
        src = ./tools/stechec2-run;
        pyproject = false;
        propagatedBuildInputs = with pkgs.python3Packages; [
          pyyaml
        ];
        dontUnpack = true;
        installPhase = ''
          install -Dm755 $src "$out/bin/$name"
        '';
      };
      stechec2-all = pkgs.symlinkJoin {
        name = "stechec2";
        paths = [
          stechec2
          stechec2-generator
          stechec2-run
        ];
      };
    in rec {
      formatter = pkgs.alejandra;
      packages = {
        inherit stechec2 stechec2-generator stechec2-run stechec2-all;

        tictactoe = lib.stechec2.mkStechec2Game {
          name = "tictactoe";
          src = ./games/tictactoe;
        };

        plusminus = lib.stechec2.mkStechec2Game {
          name = "plusminus";
          src = ./games/plusminus;
          doCheck = false;
        };
      };
      lib.stechec2 = import ./stechec2.nix {inherit pkgs stechec2 stechec2-generator;};
      devShells = {
        stechec2 = pkgs.mkShell {
          buildInputs = with pkgs; [
            gtest
            isolate
            pkg-config
            stechec2
          ];
          inputsFrom = [stechec2];
        };
        default = pkgs.mkShell {
          nativeBuildInputs = [stechec2 stechec2-generator stechec2-run];
        };
        generatorAllLanguages = pkgs.mkShell {
          nativeBuildInputs = [
            stechec2-generator
            pkgs.python3
            pkgs.php
            pkgs.php82Extensions.ffi
            pkgs.php82Extensions.ffi.dev
            pkgs.php82Extensions.ctype
            pkgs.dotnet-sdk
            pkgs.mono5
            pkgs.maven
            pkgs.gradle
            pkgs.clang
            pkgs.gcc
            pkgs.gnumake
            pkgs.ocaml
            pkgs.rustc
            pkgs.cargo
            pkgs.nodejs
            pkgs.jdk
            pkgs.ghc
            pkgs.spidermonkey_91
            pkgs.spidermonkey_91.dev
          ];
        };
      };
    });
}
