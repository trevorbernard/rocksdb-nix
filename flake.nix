{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    flake-utils,
    ...
    }:
    flake-utils.lib.eachSystem ["aarch64-darwin" "x86_64-linux"] (
      system: let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

        rustPlatform = pkgs.makeRustPlatform {
          cargo = rust;
          rustc = rust;
        };

        runtimeDependencies = with pkgs; [
          openssl
        ];

        frameworks = pkgs.darwin.apple_sdk.frameworks;

        buildDependencies = with pkgs; [
            llvmPackages.libclang
            clang
            pkg-config
            rustPlatform.bindgenHook]
          ++ runtimeDependencies
          ++ lib.optionals stdenv.isDarwin [
            frameworks.Security
            frameworks.CoreServices
          ];

        developmentDependencies = with pkgs; [
            rust
          ]
          ++ buildDependencies;

        cargo-toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      in
        with pkgs; {
          packages = flake-utils.lib.flattenTree rec {
            rocksdb-nix = rustPlatform.buildRustPackage rec {
              pname = cargo-toml.package.name;
              version = cargo-toml.package.version;
              
              src = ./.;
              cargoLock = {
                lockFile = ./Cargo.lock;
              };

              nativeBuildInputs = buildDependencies;
              buildInputs = runtimeDependencies;

              env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

              doCheck = false;
            };

            default = rocksdb-nix;
          };

          devShells.default = mkShell {
            buildInputs = developmentDependencies;
            shellHook = ''
              export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"
            '';
          };
        }
    );
}
