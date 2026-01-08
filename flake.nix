{
  description = "Haskell MOOC flake";

  # Info on development environments: https://nixos-and-flakes.thiscute.world/development/intro

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    haskellPackagesSrc.url = "github:nixos/nixpkgs/4e6868b1aa3766ab1de169922bb3826143941973"; # lts-20.25
  };

  outputs = {nixpkgs, ...} @ inputs: let
    # This should match the system you are running on
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {inherit system;};
      haskellPackages = import inputs.haskellPackagesSrc {inherit system;};
    in
      pkgs.mkShell {
        # Create an environment with stack, ghc, etc...
        packages = [
          haskellPackages.stack
          haskellPackages.ghc
          haskellPackages.haskellPackages.zlib
          haskellPackages.zlib # The zlib.h which the haskell zlib depends on.

          haskellPackages.haskell-language-server # You might want to remove this I personally need it.

          # NOTE: If you change this remember to change the shellhook.
          pkgs.zsh # The shell you want to use
        ];

        # Any libraries that need to be dynamically linked to.
        LD_LIBRARY_PATH =
          pkgs.lib.makeLibraryPath [];

        shellHook = ''
          cd exercises
          stack build
          exec zsh
        '';
      };
  };
}
