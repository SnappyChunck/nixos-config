{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" "rust" "catppuccin" "kdl" ];
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
}
