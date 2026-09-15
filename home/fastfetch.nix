{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Define your custom ASCII logo here.
  # Nix multi-line strings ('') handle all the escaping for you.
  customLogo = ''
        _    ___    _
        +o\   \  \  / \
        \oo\   \  \/  /
      ,oo+oo+ooo\   ,/ +\
     <ooooooooooo\  \ /os;
         /``/     \  ,oo/
    ,─~─'  /       \,oooooo,
    \__   ;s       /oo/sss>`
      /  /so\_____/ss/____
     `, / \oo\    ```     /
      \/ /sooo\─~~.  .─~─`
        /so/\oo\   \  \
        \o/  \s+\   \__\
              ```
  '';
in
{
  # Automatically generate the logo.txt file in the correct XDG config path
  xdg.configFile."fastfetch/logo.txt".text = customLogo;

  programs.fastfetch = {
    enable = true;

    # Nix automatically serializes this attribute set into valid JSON
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        source = "~/.config/fastfetch/logo.txt";
        padding = {
          top = 1;
          right = 0;
          left = 0;
        };
      };

      display = {
        separator = " ";
      };

      modules = [
        {
          type = "custom";
          key = "╭───────────╮";
        }
        {
          type = "title";
          key = "│ {#31} user    {#keys}│";
          format = "{user-name}";
        }
        {
          type = "uptime";
          key = "│ {#33}󰅐 uptime  {#keys}│";
        }
        {
          type = "display";
          key = "│ {#32} display {#keys}│";
          compactType = "original-with-refresh-rate";
        }
        {
          type = "os";
          key = "│ {#34}{icon} distro  {#keys}│";
        }
        {
          type = "kernel";
          key = "│ {#35} kernel  {#keys}│";
        }
        {
          type = "wm";
          key = "│ {#36}󰧨 wm      {#keys}│";
        }
        {
          type = "terminal";
          key = "│ {#31} term    {#keys}│";
        }
        {
          type = "packages";
          key = "│ {#33}󰏖 apps    {#keys}│";
          #format = "{all} (total)";
        }

        {
          type = "disk";
          key = "│ {#34}󰉉 disk    {#keys}│";
          folders = "/";
        }
        {
          type = "memory";
          key = "│ {#36}󰍛 memory  {#keys}│";
        }
        {
          type = "custom";
          key = "├───────────┤";
        }
        {
          type = "colors";
          key = "│ {#39} colors  {#keys}│";
          symbol = "circle";
        }
        {
          type = "custom";
          key = "╰───────────╯";
        }
      ];
    };
  };
}
