{
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

  xdg.configFile."fastfetch/cat.txt".text = ''
    /| ､
   (°､ ｡ 7
    |､  ~ヽ
    じしf_,)〳
  '';
}
