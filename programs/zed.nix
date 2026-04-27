{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" "rust" "catppuccin" "kdl" "tokyo-night" ];
    userSettings = {
      theme = {
        mode = "system";
        #dark = "Catppuccin Mocha";
        dark = "Tokyo Night Moon":
        light = "One Light";
      };
      hour_format = "hour24";
      vim_mode = false;
    };
  };
}
