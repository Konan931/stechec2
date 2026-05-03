{
  description = "Stechec2 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
          php-unwrapped-prologin = final.php.unwrapped.overrideAttrs (attrs: {
            configureFlags = attrs.configureFlags ++ ["--enable-embed"];
          });

          php-prologin = final.php.overrideAttrs (attrs: {
            unwrapped = final.php-unwrapped-prologin;
          });

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
      checks.champions = pkgs.stdenv.mkDerivation {
        name = "champions";
        src = ./.;
        doCheck = true;
        nativeBuildInputs = with pkgs; [
          pkg-config
          which
          cargo
          clang
          gcc
          ghc
          glib.dev
          gnumake
          jdk
          libargon2
          libxml2
          maven
          mono
          ncurses
          nodejs
          ocaml
          pcre2
          php-prologin
          php-unwrapped-prologin.dev
          python3
          python3Packages.pytest
          rustc
          spidermonkey_128
          spidermonkey_128.dev
          stechec2-generator
          stechec2-run
        ] ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
          pkgs.systemd
        ];
        checkPhase = ''
          mktemp -d
          mkdir -p $out/tests
          cp -r $src/tests/env_tester $out/tests

          mkdir -p $out/build/src/server
          cp -r ${pkgs.stechec2-all}/bin/stechec2-server $out/build/src/server

          mkdir -p $out/build/src/client
          cp -r ${pkgs.stechec2-all}/bin/stechec2-client $out/build/src/client

          mkdir -p $out/build/games/tictactoe
          cp -r ${packages.tictactoe}/lib/libtictactoe.so $out/build/games/tictactoe

          mkdir -p $out/games/tictactoe
          cp ${packages.tictactoe}/share/stechec2/tictactoe/tictactoe.yml $out/games/tictactoe/tictactoe.yml

          cd $out/tests/env_tester
          pytest tests.py
        '';
      };

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
            pkg-config
            stechec2
          ];
          inputsFrom = [
            pkgs.stechec2
          ];
        };
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.gtest
            pkgs.pkg-config
            pkgs.stechec2
            pkgs.stechec2-generator
            pkgs.stechec2-run
          ];
          inputsFrom = [
            pkgs.stechec2
          ];
        };
        generatorAllLanguages = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.stechec2-generator
            pkgs.stechec2-run
            pkgs.python3
            pkgs.python3Packages.pytest
            pkgs.cmake
            pkgs.pkg-config
            pkgs.cppzmq
            pkgs.gflags
            pkgs.libsodium
            pkgs.stechec2
            pkgs.php
            pkgs.php82Extensions.ffi
            pkgs.php82Extensions.ffi.dev
            pkgs.php82Extensions.ctype
            pkgs.dotnet-sdk
            pkgs.mono
            pkgs.glib.dev
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
            pkgs.spidermonkey_128
            pkgs.spidermonkey_128.dev
          ];
        };
      };
    }));
}
