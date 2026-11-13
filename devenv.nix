{
  pkgs,
  ...
}:

{
  languages.terraform.enable = true;
  languages.python.enable = true;
  languages.ansible.enable = true;

  packages = with pkgs; [
    lua-language-server # LSP for Lua
    nil # LSP for Nix
  ];
}
