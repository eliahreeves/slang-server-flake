{
  description = "A flake for Slang LSP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = {
        default = pkgs.llvmPackages_19.stdenv.mkDerivation {
          pname = "slang-server";
          version = "0.2.2";

          src = pkgs.fetchgit {
            url = "https://github.com/hudson-trading/slang-server.git";
            fetchSubmodules = true;
            hash = "sha256-Up+dD8zT+c5ESWNaEqoffgtmr42Fc8DIt0ISESkx4Zw=";
          };

          buildInputs = with pkgs; [
            catch2_3
            fmt
            mimalloc
          ];

          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            python3
          ];

          cmakeFlags = [
            "-DCMAKE_DISABLE_FIND_PACKAGE_fmt=OFF"
            "-Dmimalloc_DIR=${pkgs.mimalloc}/lib/cmake/mimalloc"
            "-DCMAKE_CXX_SCAN_FOR_MODULES=OFF"
          ];
          buildFlags = ["slang_server"];
        };
      };
    });
}
