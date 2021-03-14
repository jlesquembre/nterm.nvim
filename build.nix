{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs { }
, nix-medley ? import sources.nix-medley { inherit pkgs; }
}:
(nix-medley.neovim.compileAniseedPlugin
  {
    src = pkgs.lib.cleanSource ./.;
    fnlDir = "src";
    asVimPlugin = false;
  }
)
