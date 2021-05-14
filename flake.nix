{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    pypi-deps-db = {
      url = github:DavHau/pypi-deps-db/bada1c33c0040398aa9465ccd60845d31343cc3a;
      flake = false;
    };
    mach-nix = {
      url = github:DavHau/mach-nix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pypi-deps-db.follows = "pypi-deps-db";
    };
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix, pypi-deps-db }:
  flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
  let
    pkgs = import nixpkgs { inherit system; };
    mach-nix-utils = import mach-nix {
      inherit pkgs;
      # pypiDataRev = pypi-deps-db.rev;
      # pypiDataSha256 = pypi-deps-db.narHash;

      # TODO: maybe doing this should be an error
      # pypi_deps_db_commit = pypi-deps-db..rev;
      # pypiDataSha256 = pypi-deps-db.narHash;
    };
  in {
    devShell = mach-nix-utils.mkPythonShell {
      requirements = builtins.readFile ./requirements.txt;
    };

    packages.sensor-python-package = mach-nix-utils.buildPythonPackage {
      tests = true;
      src = ./.;
      requirements = builtins.readFile ./requirements.txt;
    };

    # this is the nicest way I found to create
    # * a shell with dependenices
    # * a python package
    # * a python instance with that package installed
    # from the same source
    # TODO: look into why building this creates collisions
    #packages.sensor-python = mach-nix-utils.mkPython [
    #  self.packages.${system}.sensor-python-package
    #];

    defaultPackage = self.packages.${system}.sensor-python-package;

  });
}
