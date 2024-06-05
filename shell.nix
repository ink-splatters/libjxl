with import <nixpkgs> {} ;
mkShell.override { inherit (llvmPackages_18) stdenv; } {

    buildInputs = [
	brotli
	pkg-config
    ];

    nativeBuildInputs = [
	clang_18
	lld_18
	llvmPackages_18.bintools
	cmake
	ninja
	libpng
    ];


    LDFLAGS="-fuse-ld=lld -flto=full";
    CFLAGS="-mcpu=apple-m1 -O3";
    CXXFLAGS="-mcpu=apple-m1 -O3";
}
