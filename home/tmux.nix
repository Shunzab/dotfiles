{
  config,
  lib,
  pkgs,
  ...
}:
let
c = if (config ? lib.stylix.colors.withHashtag) then config.lib.stylix.colors.withHashtag else { };

# Corrected Base16 mappings for block/pill status bars
thm_bg     = c.base00 or "#1a1b26"; # Main status bar background
thm_fg     = c.base06 or "#c0caf5"; # High-contrast foreground text
thm_gray   = c.base01 or "#2e3c64"; # Pill container background (Fixed: base01 instead of base03)
thm_black  = c.base02 or "#15161e"; # Secondary dark fill / active selection
thm_black4 = c.base03 or "#565f89"; # Borders and muted comments

# Accent badges
thm_cyan    = c.base0C or "#86e1fc";
thm_magenta = c.base0E or "#c099ff";
thm_pink    = c.base08 or "#ff757f";
thm_red     = c.base08 or "#ff757f";
thm_green   = c.base0B or "#c3e88d";
thm_yellow  = c.base0A or "#ffc777";
thm_blue    = c.base0D or "#82aaff";
thm_orange  = c.base09 or "#ff9e64";

in
{
  stylix.targets.tmux.enable = false;

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;

    # These generate tmux settings automatically — no need to repeat in extraConfig
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    terminal = "tmux-256color";

    extraConfig = ''
      # Terminal overrides
      set -ga terminal-overrides ",*:RGB"
      set -g set-clipboard on
      set -g focus-events on
      set -g alternate-screen on
      set -as terminal-overrides ',xterm*:smcup@:rmcup@'
      set -g status-interval 1

      # Pane/window behavior
      set -g pane-base-index 1
      set -g renumber-windows on
      set -g detach-on-destroy off

      # Prefix
      unbind C-b
      bind-key C-a send-prefix

      # Vim pane selection (prefix + hjkl)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Splits
      unbind %
      unbind '"'
      bind -n M-| split-window -h -c "#{pane_current_path}"
      bind -n M-- split-window -v -c "#{pane_current_path}"

      # Windows & sessions
      bind -n M-C new-window -c "#{pane_current_path}"
      bind -n M-s choose-tree -s
      bind -n M-R source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Reloaded"

      # Alt+hjkl pane switching

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Alt+number window switching
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2

      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5

      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # Alt+H/L prev/next window
      bind -n M-H previous-window
      bind -n M-L next-window

      # Vim copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Status bar setup
      set -g status "on"
      set -g status-bg "${thm_bg}"
      set -g status-style "bg=default"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-position top

      # Messages
      set -g message-style "fg=${thm_cyan},bg=${thm_gray},align=centre"
      set -g message-command-style "fg=${thm_cyan},bg=${thm_gray},align=centre"

      # Panes
      set -g pane-border-style "fg=${thm_gray}"
      set -g pane-active-border-style "fg=${thm_blue}"

      # Windows styling & spacing
      set -g window-status-activity-style "fg=${thm_fg},bg=${thm_bg},none"
      set -g window-status-separator " "
      set -g window-status-style "fg=${thm_fg},bg=${thm_bg},none"

      # Statusline - Left side (Session pill + Leader key active = Pink / Idle = Green)
      set -g status-left "#{?client_prefix,#[fg=${thm_pink}],#[fg=${thm_green}]}#[bg=${thm_bg}]#{?client_prefix,#[bg=${thm_pink}],#[bg=${thm_green}]}#[fg=${thm_bg},bold] #[fg=${thm_fg},bg=${thm_gray}] #S #[fg=${thm_gray},bg=${thm_bg}] "

      # Statusline - Current/Active window (Orange accent badge)
      set -g window-status-current-format "#[fg=${thm_gray},bg=${thm_bg}]#[fg=${thm_fg},bg=${thm_gray},bold]#W #[fg=${thm_bg},bg=${thm_orange},bold] #I #[fg=${thm_orange},bg=${thm_bg}]"

      # Statusline - Inactive windows (Blue accent badge)
      set -g window-status-format "#[fg=${thm_gray},bg=${thm_bg}]#[fg=${thm_fg},bg=${thm_gray}]#W #[fg=${thm_bg},bg=${thm_blue}] #I #[fg=${thm_blue},bg=${thm_bg}]"

      # Statusline - Right side (Pink Path Pill + Blue Time Pillr
      set -g status-right "#[fg=${thm_pink},bg=${thm_bg}]#[fg=${thm_bg},bg=${thm_pink}] #[fg=${thm_fg},bg=${thm_gray}] #(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=${thm_gray},bg=${thm_bg}] #[fg=${thm_blue},bg=${thm_bg}]#[fg=${thm_bg},bg=${thm_blue}]󰃰 #[fg=${thm_fg},bg=${thm_gray}] %H:%M #[fg=${thm_gray},bg=${thm_bg}]"

      # Modes
      set -g clock-mode-colour "${thm_blue}"
      set -g mode-style "fg=${thm_blue} bg=${thm_black4} bold"

    '';
  };
}
