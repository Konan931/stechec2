{
  pkgs,
  stechec2,
  stechec2-generator,
}: {
  mkStechec2Game = {
    name,
    src,
    doCheck ? true,
    cmakeFlags ? [],
    buildPlayerEnvironment ? true,
  }: let
    game = pkgs.stdenv.mkDerivation {
      inherit name src doCheck;
      cmakeFlags =
        (
          if doCheck
          then ["-DBUILD_TESTING=ON"]
          else []
        )
        ++ cmakeFlags;
      propagatedBuildInputs = [
        pkgs.cppzmq
        pkgs.gflags
        pkgs.libsodium
        stechec2
      ];
      nativeBuildInputs = [
        pkgs.cmake
        pkgs.gtest
        stechec2
      ];
    };
    playerEnvironment = pkgs.runCommand "${name}-player-environment" {} ''
      mkdir -p $out/share/stechec2/${name}/player
      ${stechec2-generator}/bin/stechec2-generator \
        player \
        ${game}/share/stechec2/${name}/${name}.yml \
        $out/share/stechec2/${name}/player
    '';
  in
    pkgs.symlinkJoin {
      inherit name;
      paths = [
        game
        (pkgs.lib.optional buildPlayerEnvironment playerEnvironment)
      ];
    };
}
