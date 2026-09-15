{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    lua-language-server # LSP for Lua
    nil # LSP for Nix
  ];

  languages.lua = {
    enable = true;
    package = pkgs.luajit;
  };
}
