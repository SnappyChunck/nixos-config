{ config, pkgs, lib, ... }:

{
  home.username = "fio";
  home.homeDirectory = "/home/fio";

  xresources.properties = {
    "Xcursor.size" = 16;
  };

  home.packages = with pkgs; [
    which
    nautilus
    curl
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" "rust" "catppuccin" ];
    userSettings = {
      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "One Light";
      };
      hour_format = "hour24";
      vim_mode = false;
    };
  };

  programs.kitty = {
    enable = true;

    font = {
      name = "Fira Code";
      size = 11.0;
    };

    extraConfig = ''
        font_features FiraCode-Retina +cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum
        font_features FiraCode-Regular +cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum
        font_features FiraCode-Bold    +cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum
    '';

    settings = {

      confirm_os_window_close = 0;

      shell = "fish";

      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      window_margin_width = 0;
      window_padding_width = 10;
      modify_font = "cell_height 130%";

      # The basic colors
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";

      # Cursor colors
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";

      # URL underline color when hovering with mouse
      url_color = "#F5E0DC";

      # Kitty window border colors
      active_border_color = "#B4BEFE";
      inactive_border_color = "#6C7086";
      bell_border_color = "#F9E2AF";

      # OS Window titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";

      # Tab bar colors
      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";

      # Colors for marks (marked text in the terminal)
      mark1_foreground = "#1E1E2E";
      mark1_background = "#B4BEFE";
      mark2_foreground = "#1E1E2E";
      mark2_background = "#CBA6F7";
      mark3_foreground = "#1E1E2E";
      mark3_background = "#74C7EC";

      # The 16 terminal colors

      # black
      color0 = "#45475A";
      color8 = "#585B70";

      # red
      color1 = "#F38BA8";
      color9 = "#F38BA8";

      # green
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";

      # yellow
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";

      # blue
      color4 = "#89B4FA";
      color12 = "#89B4FA";

      # magenta
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";

      # cyan
      color6 = "#94E2D5";
      color14 = "#94E2D5";

      # white
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };
  };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide;
      }
    ];

    functions = {
        fish_greeting = "fastfetch";
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "~/.config/fastfetch/cat.txt";
        color."1" = "green";
        padding = { top = 1; right = 6; };
      };
      display = {
            separator = "  ";
            color = { keys = "green"; output = "white"; };
      };
      modules = [
        { type = "title"; color = { user = "yellow"; at = "white"; host = "yellow"; }; }
        "host"
        "os"
        "kernel"
        "uptime"
        "packages"
      ];
    };
  };

  home.activation.configure-tide = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Lean --prompt_colors='16 colors' --show_time=No --lean_prompt_height='One line' --prompt_spacing=Sparse --icons='Few icons' --transient=No"
  '';

  xdg.configFile."fastfetch/cat.txt".text = ''
    /| ､
   (°､ ｡ 7
    |､  ~ヽ
    じしf_,)〳
  '';

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = null;
  };

  xdg.configFile."mango" = {
    source = ./mango;
    recursive = true;
  };

  xdg.configFile."DankMaterialShell" = {
    source = ./DankMaterialShell;
    recursive = true;
  };

  home.stateVersion = "25.11";
}
