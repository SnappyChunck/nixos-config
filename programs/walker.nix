{ inputs, lib, ... }:
{
  imports = [ inputs.walker.homeManagerModules.default ];

  xdg.configFile."elephant/menus/power.toml".text = ''
    name = "power"
    name_pretty = "Power"

    [[entries]]
    text = "Shutdown"
    icon = "system-shutdown-symbolic"
    actions = { "shutdown" = "systemctl poweroff" }

    [[entries]]
    text = "Reboot"
    icon = "system-reboot-symbolic"
    actions = { "reboot" = "systemctl reboot" }

    #[[entries]]
    #text = "Suspend"
    #icon = "weather-clear-night-symbolic"
    #actions = { "suspend" = "systemctl suspend" }

    [[entries]]
    text = "Logout"
    icon = "system-log-out-symbolic"
    actions = { "logout" = "niri msg action quit" }
  '';

  xdg.configFile."elephant/menus/main.toml".text = ''
    name = "main"
    name_pretty = "Main"

    [[entries]]
    text = "Apps"
    icon = "applications-all-symbolic"
    actions = { "open" = "walker" }

    [[entries]]
    text = "Power"
    icon = "system-shutdown-symbolic"
    submenu = "power"
  '';

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      force_keyboard_focus = true;
      selection_wrap = true;
      theme = "catppuccin-mocha";
      hide_action_hints = true;

      placeholders."default" = {
        input = " Search...";
        list = "No Results";
      };

      keybinds.quick_activate = [];

      columns.symbols = 1;

      providers = {
        max_results = 256;
        default = [ "desktopapplications" "websearch" ];
        prefixes = [
          { prefix = "/"; provider = "providerlist"; }
          { prefix = "."; provider = "files"; }
          { prefix = ":"; provider = "symbols"; }
          { prefix = "="; provider = "calc"; }
          { prefix = "@"; provider = "websearch"; }
          { prefix = "$"; provider = "clipboard"; }
        ];
      };

      emergencies = [
        { text = "Restart Walker"; command = "systemctl --user restart walker"; }
      ];
    };

    themes."catppuccin-mocha" = {
      style = ''
        @define-color selected-text #7aa2f7;
        @define-color text #a9b1d6;
        @define-color base #1a1b26;
        @define-color border #a9b1d6;
        @define-color foreground #a9b1d6;
        @define-color background #1a1b26;

        * {
          all: unset;
        }

        * {
          font-family: "FiraCode Nerd Font", monospace;
          font-size: 18px;
          color: @text;
        }

        scrollbar {
          opacity: 0;
        }

        .normal-icons {
          -gtk-icon-size: 16px;
        }

        .large-icons {
          -gtk-icon-size: 32px;
        }

        .box-wrapper {
          background: alpha(@base, 0.95);
          padding: 20px;
          border: 2px solid @border;
        }

        .preview-box {
        }

        .box {
        }

        .search-container {
          background: @base;
          padding: 10px;
        }

        .input placeholder {
          opacity: 0.5;
        }

        .input {
        }

        .input:focus,
        .input:active {
          box-shadow: none;
          outline: none;
        }

        .content-container {
        }

        .placeholder {
        }

        .scroll {
        }

        .list {
        }

        child,
        child > * {
        }

        child:hover .item-box {
        }

        child:selected .item-box {
        }

        child:selected .item-box * {
          color: @selected-text;
        }

        .item-box {
          padding-left: 14px;
        }

        .item-text-box {
          all: unset;
          padding: 14px 0;
        }

        .item-text {
        }

        .item-subtext {
          font-size: 0px;
          min-height: 0px;
          margin: 0px;
          padding: 0px;
        }

        .item-image {
          margin-right: 14px;
          -gtk-icon-transform: scale(0.9);
        }

        .current {
          font-style: italic;
        }

        .keybind-hints {
          background: @background;
          padding: 10px;
          margin-top: 10px;
        }

        .preview {
        }
      '';
    };
  };
}
