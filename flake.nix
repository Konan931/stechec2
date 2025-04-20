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
  }: ({
      lib.stechec2 = import ./stechec2.nix;
      overlays = {
        default = final: prev: {
          stechec2 = final.stdenv.mkDerivation {
            name = "stechec2";
            version = "2.0.0";
            src = ./.;
            propagatedBuildInputs = with final; [
              cppzmq
              gflags
              libsodium
            ];
            nativeBuildInputs = with final; [cmake];
          };
          stechec2-generator = final.python3Packages.buildPythonPackage {
            name = "stechec2-generator";
            src = ./tools;
            pyproject = true;
            build-system = [
              final.python3Packages.hatchling
            ];
            propagatedBuildInputs = with final.python3Packages; [
              pyyaml
              jinja2
            ];
          };
          stechec2-run = final.python3Packages.buildPythonApplication {
            name = "stechec2-run";
            src = ./tools/stechec2-run;
            pyproject = false;
            propagatedBuildInputs = with final.python3Packages; [
              pyyaml
            ];
            dontUnpack = true;
            installPhase = ''
              install -Dm755 $src "$out/bin/$name"
            '';
          };
          stechec2-all = final.symlinkJoin {
            name = "stechec2";
            paths = [
              final.stechec2
              final.stechec2-generator
              final.stechec2-run
            ];
          };
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      };
    in rec {
      formatter = pkgs.alejandra;
      packages = let
        libStechec2 = self.lib.stechec2 {inherit pkgs;};
      in {
        inherit (pkgs) stechec2 stechec2-generator stechec2-run stechec2-all;

        tictactoe = libStechec2.mkStechec2Game {
          name = "tictactoe";
          src = ./games/tictactoe;
        };

        plusminus = libStechec2.mkStechec2Game {
          name = "plusminus";
          src = ./games/plusminus;
          doCheck = false;
        };
      };
      devShells = {
        stechec2 = pkgs.mkShell {
          buildInputs = with pkgs; [
            gtest
            isolate
            pkg-config
            stechec2
          ];
          inputsFrom = [
            pkgs.stechec2
          ];
        };
        default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.stechec2
            pkgs.stechec2-generator
            pkgs.stechec2-run
          ];
        };
        generatorAllLanguages = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.stechec2-generator
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
    }));
}
