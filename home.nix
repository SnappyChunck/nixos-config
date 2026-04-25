{ config, pkgs, lib, inputs, ... }:

{
  home.stateVersion = "25.11";

  imports = [
    ./programs/git.nix # Git
    ./programs/zed.nix # Zed editor
    ./programs/spicetify.nix # Spotify with Spicetify
    ./programs/kitty.nix # Kitty Config
    ./programs/fish.nix # Fish shell
    ./programs/fastfetch.nix # Fastfetch
    ./programs/walker.nix # Walker application launcher
    ./programs/niri.nix #wm
    ./programs/waybar.nix #bar
  ];

  home.username = "fio";
  home.homeDirectory = "/home/fio";

  home.packages = with pkgs; [
    which
    curl
    vesktop
    gnome-disk-utility
    godot
    papirus-icon-theme
    waybar
    nextcloud-client
    gnome-keyring
    libsecret
    audacity
    pavucontrol
    inputs.elephant.packages.${pkgs.stdenv.hostPlatform.system}.default
    (callPackage ./toofan.nix { })
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

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
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
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
}
