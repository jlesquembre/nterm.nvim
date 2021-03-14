let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  # nix-medley = import /home/jlle/projects/nix-medley { inherit pkgs; };

  build = import ./build.nix { inherit sources pkgs; };
  # build = import ./build.nix { inherit sources pkgs nix-medley; };

  compile =
    pkgs.writeShellScriptBin "compile"
      ''
        rm -rf lua
        cp --no-preserve=mode -r -T ${build} .
      '';

in
pkgs.mkShell {
  buildInputs = [
    compile
  ];
}
