{ config, pkgs, lib, inputs, ... }:

let
  dfr-screenshot = pkgs.writeShellApplication {
    name = "niri-screenshot";
    
    runtimeInputs = with pkgs; [ 
      grim 
      slurp 
      niri 
      jq 
      wl-clipboard 
      satty 
    ];

    text = ''
      set -o errexit
      set -o pipefail
      set -o nounset

      MODE="''${1:-region}"

      case "''${MODE}" in
      region)
        grim -g "$(slurp -d)" -
        ;;
      window)
        niri msg action screenshot-window
        sleep 0.5
        wl-paste --type image/png
        ;;
      monitor-focused)
        grim -o "$(niri msg --json focused-output | jq --raw-output .name)" -
        ;;
      monitor-all)
        grim -
        ;;
      *)
        # Bypassed Nix string issues by using standard bash backslashes for quotes
        echo \""\''${MODE}"\" is not a supported, aborting! >&2
        exit 1
        ;;
      esac | satty --filename - --output-filename "''${XDG_PICTURES_DIR}/screenshot-%+.png"
    '';
  };
in
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
    ./programs/vscode.nix
    ./programs/sway.nix
    ./programs/obs.nix
    ./programs/flameshot.nix
    ./programs/zen.nix
  ];

  services.swaync.enable = true; # notifications

  xdg.configFile."swaync/style.css".text = ''
    * {
      font-family: "FiraCode Nerd Font", monospace;
      font-size: 14px;
    }

    .notification-row {
      outline: none;
    }

    .notification {
      background-color: alpha(#1a1b26, 0.95);
      border: 2px solid #a9b1d6;
      border-radius: 0px;
      padding: 10px;
      margin: 4px;
      color: #a9b1d6;
    }

    .notification-content {
      background: transparent;
      padding: 6px;
    }

    .notification-default-action {
      background: transparent;
      border-radius: 0px;
      color: #a9b1d6;
    }

    .notification-default-action:hover {
      background-color: alpha(#7aa2f7, 0.15);
    }

    .summary {
      color: #7aa2f7;
      font-weight: bold;
    }

    .body {
      color: #a9b1d6;
    }

    .close-button {
      background-color: transparent;
      color: #a9b1d6;
      border: none;
    }

    .close-button:hover {
      background-color: alpha(#7aa2f7, 0.15);
    }
  '';

  home.username = "fio";
  home.homeDirectory = "/home/fio";

  home.packages = with pkgs; [
    which
    curl
    vesktop
    gnome-disk-utility
    #godot
    godot-mono
    papirus-icon-theme
    waybar
    nextcloud-client
    gnome-keyring
    libsecret
    audacity
    pavucontrol
    swaybg
    impala
    btop
    bluetui
    keepassxc
    direnv
    bun
    jetbrains-toolbox
    appimage-run
    nheko
    autotiling-rs
    thunderbird

    vlc

    kdePackages.kdenlive

    libreoffice

    grim
    slurp
    jq
    #satty is installed

    dfr-screenshot

    wl-clipboard

    meslo-lgs-nf

    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default

    inputs.elephant.packages.${pkgs.stdenv.hostPlatform.system}.default

    (callPackage ./toofan.nix { })
  ];

  programs.satty = {
    enable = true;
    settings = {
      general = {
        early-exit = true;
        copy-command = "wl-copy --type image/png";
        initial-tool = "brush";
      };
    };
  };

  home.enableNixpkgsReleaseCheck = false;

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "sudo"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    initContent = ''
      fastfetch
    '';

    shellAliases = {
      update = "sudo nixos-rebuild switch";
      update-flake = "cd /etc/nixos/ && sudo nixos-rebuild switch --flake .";
    };

    #histSize = 10000;
    #histFile = "$HOME/.zsh_history";
    #setOptions = [
    #  "HIST_IGNORE_ALL_DUPS"
    #];

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
    };
  };

  #system.userActivationScripts.zshrc = "touch .zshrc";
}
