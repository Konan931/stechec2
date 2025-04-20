{pkgs}: {
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
        pkgs.stechec2
      ];
      nativeBuildInputs = [
        pkgs.cmake
        pkgs.gtest
        pkgs.stechec2
      ];
    };
    playerEnvironment = pkgs.runCommand "${name}-player-environment" {} ''
      mkdir -p $out/share/stechec2/${name}/player
      ${pkgs.stechec2-generator}/bin/stechec2-generator \
        player \
        ${game}/share/stechec2/${name}/${name}.yml \
        $out/share/stechec2/${name}/player
    '';
  in
    # FIXME : better permissions handling
    pkgs.runCommand "${name}" {} ''
      mkdir -p $out
      cp --no-preserve=mode -r ${game}/* $out/
      chmod +x $out/lib/lib${name}.so
      ${if buildPlayerEnvironment then "cp --no-preserve=mode -r ${playerEnvironment}/* $out/" else ""}
    '';
}
