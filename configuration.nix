{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  networking.networkmanager.enable = false;

  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
      };
      Rank = {
        BandModifier5GHz = "2.0";
      };
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  services.xserver.excludePackages = [
    pkgs.xterm
    pkgs.khal
  ];

  services.irqbalance.enable = true;

  console.keyMap = "de";

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    #
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    packages = [
      "com.github.tchx84.Flatseal"
      "com.unity.UnityHub"
      "it.mijorus.gearlever"
      "org.prismlauncher.PrismLauncher"
      "at.vintagestory.VintageStory"
      "net.davidotek.pupgui2"
    ];
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix"; # "matrix"; #"dur_file";
      dur_file_path = "/etc/nixos/assets/blackhole-smooth-240x67.dur"; # "/etc/nixos/assets/blackhole.dur";
      full_color = true;

      fg = "0x00FFFFFF"; # white text
      border_fg = "0x00FFFFFF";
    };
  };

  environment.etc."ly/startup.sh" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      if [ "$TERM" = "linux" ]; then
        BLACK="000000"
        DARK_RED="D75F5F"
        DARK_GREEN="87AF5F"
        DARK_YELLOW="D7AF87"
        DARK_BLUE="8787AF"
        DARK_MAGENTA="BD53A5"
        DARK_CYAN="5FAFAF"
        LIGHT_GRAY="E5E5E5"
        DARK_GRAY="2B2B2B"
        RED="FF8C00"
        GREEN="98E34D"
        YELLOW="FFD700"
        BLUE="7373C9"
        MAGENTA="FF4500"
        CYAN="44C9C9"
        WHITE="FFFFFF"
        COLORS="$BLACK $DARK_RED $DARK_GREEN $DARK_YELLOW $DARK_BLUE $DARK_MAGENTA $DARK_CYAN $LIGHT_GRAY $DARK_GRAY $RED $GREEN $YELLOW $BLUE $MAGENTA $CYAN $WHITE"
        i=0
        while [ $i -lt 16 ]; do
          printf "\033]P%x%s" $i "$(echo "$COLORS" | cut -d ' ' -f$(( i + 1)))"
          i=$(( i + 1 ))
        done
        clear
      fi
    '';
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.gnome.gnome-keyring.enable = true;
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.udisks2.enable = true;
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  services.usbmuxd.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];

    config = {
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Background" = [ "gnome" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  nixpkgs.config.rocmSupport = true;

  hardware.amdgpu.opencl.enable = true;

  users.users.fio = {
    isNormalUser = true;
    description = "fio";
    shell = pkgs.zsh; # pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "input"
      "dialout"
      "uucp"
    ];
  };

  security.polkit.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      #webstorm
      libx11
      libxext
      libxi
      libxrender
      libxtst
      fontconfig

      #helium
      libxcb
      libgbm
      libxkbcommon
      libXcomposite
      libXdamage
      libXfixes
      libXrandr
      glib
      nss
      nspr
      atk
      at-spi2-atk
      cups
      libdrm
      dbus
      mesa
      gtk3
      expat
      pango
      cairo
      alsa-lib

      #Karlson
      gtk2
      gdk-pixbuf
      freetype

      icu

      #virtual Cam
      v4l-utils

      #spot
      webkitgtk_4_1

      qt6.qtbase
      qt6.qttools
      qtcreator

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
    ];
  };

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;
  programs.niri.enable = true;

  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = true;
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.dconf.enable = true;
  programs.sway.enable = true;
  programs.uwsm.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    let
      durdraw = pkgs.python3Packages.buildPythonPackage {
        pname = "durdraw";
        version = "latest";
        src = inputs.durdraw;
        format = "pyproject";
        build-system = [ pkgs.python3Packages.setuptools ];
        doCheck = false;
      };
    in
    with pkgs;
    [
      r2modman

      #dotnetCorePackages.dotnet_10
      dotnetCorePackages.sdk_10_0

      #neovim
      git
      wget
      gcc
      killall
      bibata-cursors
      xwayland-satellite
      nautilus

      gnome-tweaks

      polkit_gnome
      iw
      playerctl
      python3
      #wine
      gtk3
      glib
      durdraw

      #Rust global
      #rustc
      #cargo
      #clippy
      #rust-analyzer
      #rustfmt
      gcc

      (rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
        ];
      })

      #Rust Projects
      pkg-config
      openssl.dev

      dxvk
      winetricks

      ghidra-bin

      wineWow64Packages.stable

      winetricks
      dxvk

      cabextract
      p7zip
      yad
      xrandr
      gnumeric
      coreutils
      lsb-release
      mesa-demos
      samba
      bc
      mokutil
      desktop-file-utils

      gamescope

      blender

      krita

      nixd
      nixfmt

      meson
      ninja

      gettext
      desktop-file-utils
      appstream
      glib
      glib.dev
      blueprint-compiler
      graphene
      libxml2
      pkg-config

      webkitgtk_4_1

      ffmpeg-full

      tree

      p7zip

      lact

      protonup-qt
      mangohud
    ];

  programs.zsh.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.variables.EDITOR = "vim";
  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # for nheko :(
    "olm-3.2.16"
  ];

  hardware.amdgpu.overdrive.enable = true;
  services.lact.enable = true;

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  system.stateVersion = "25.11";
}
