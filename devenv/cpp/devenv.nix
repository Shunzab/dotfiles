{ pkgs, ... }:

{
  languages.cplusplus = {
    enable = true;
    lsp.package = pkgs.clang-tools; # provides clangd
  };

  packages = with pkgs; [
    neocmakelsp
  ];
}
