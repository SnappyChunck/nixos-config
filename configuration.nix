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

  services.displayManager.ly = {
    enable = true;
    #settings = {
    #  animate = true;
    #  animation = "dur_file";
    #  dur_path = "${./assets/blackhole.dur}";
    #  dur_file = "${./assets/blackhole.dur}";
    #};
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
    shell = pkgs.fish;
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
    ];
  };

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.dconf.enable = true;
  services.flatpak.enable = true;
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

      #neovim
      git
      wget
      gcc
      killall
      bibata-cursors
      xwayland-satellite
      nautilus
      polkit_gnome
      iw
      playerctl
      python3
      #wine
      gtk3
      glib
      durdraw

      #Rust global
      rustc
      cargo
      rust-analyzer
      gcc

      #Rust Projects
      pkg-config
      openssl.dev

      dxvk
      winetricks

      ghidra-bin

      wineWow64Packages.stagingFull

      blender

      krita

      nixd
      nixfmt
    ];

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

  system.stateVersion = "25.11";
}
