{ 
  brotli, 
  clang_18,
  lib,
  libpng,
  lld_18,
  llvmPackages_18,
  mkShell,
  ninja,
  pkg-config,
  system,... }:

let
    CFLAGS = "-O3  -ffast-math -funroll-loops" + 
        lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
    CXXFLAGS = "${CFLAGS}";
    LLDFLAGS="-flto -fuse-ld=lld";

    inherit (llvmPackages_18) stdenv;

  override = thing: 
    (thing.overrideAttrs( _oa: {
      inherit CFLAGS CXXFLAGS LDFLAGS;
        nativeBuildInputs = _oa.nativeBuildInputs ++ [ ninja ];
        })).override {

            inherit stdenv;
      };


  bro = override brotli;
  lpng = override libpng;
in
mkShell.override { inherit stdenv; } {
  inherit CFLAGS CXXFLAGS LDFLAGS;

    buildInputs = [
      bro
      pkg-config
    ];

    nativeBuildInputs = [
      clang_18
      lld_18
      llvmPackages_18.bintools
      cmake
      ninja
      lpng
    ];

    hardeningDisable=["all"];
}

