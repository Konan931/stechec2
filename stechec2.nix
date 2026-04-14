{pkgs}: {
  mkStechec2Game = {
    name,
    src,
    doCheck ? true,
    cmakeFlags ? [],
    buildPlayerEnvironment ? true,
  }:
    pkgs.stdenv.mkDerivation {
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
      postInstall = pkgs.lib.optionalString buildPlayerEnvironment ''
        ${pkgs.stechec2-generator}/bin/stechec2-generator player \
            $out/share/stechec2/${name}/${name}.yml $out/share/stechec2/${name}/player
      '';
    };
}
