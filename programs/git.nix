{
  programs.git = {
    enable = true;
    settings = {
      user.name = "SnappyChunck";
      user.email = "fionn.suephke@wirnet.de";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
