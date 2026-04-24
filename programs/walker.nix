{ inputs, ... }:
{
  imports = [ inputs.walker.homeManagerModules.default ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      force_keyboard_focus = true;
      selection_wrap = true;
      theme = "catppuccin-mocha";
      hide_action_hints = true;

      placeholders."default" = {
        input = " Search...";
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
  };
}
