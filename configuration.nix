{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  #networking.networkmanager.enable = true;

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

  #environment.etc."usr/share/wayland-sessions/niri-ly.desktop".text = ''
  #  [Desktop Entry]
  #  Name=Niri (Ly Fix)
  #  Comment=Niri wrapper for Ly Display Manager
  #  Exec=niri-ly
  #  Type=Application
  #'';

  console.keyMap = "de";

  #services.displayManager.ly.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.udisks2.enable = true;
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

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

  nixpkgs.config.rocmSupport = true;

  hardware.amdgpu.opencl.enable = true;

  users.users.fio = {
    isNormalUser = true;
    description = "fio";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "input" "dialout" "uucp" ];
  };

  security.polkit.enable = true;
  #security.pam.services.ly.enableGnomeKeyring = true;

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.dconf.enable = true;
  services.flatpak.enable = true;

  #programs.dms-shell = {
  #  enable = true;
  #  systemd.enable = true;
  #};

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     neovim
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
     #(writeShellScriptBin "niri-ly" ''
     #  export XDG_SESSION_TYPE=wayland
     #  export XDG_SESSION_DESKTOP=niri
     #  export XDG_CURRENT_DESKTOP=niri

     #  if [ -f "$HOME/.profile" ]; then
     #    . "$HOME/.profile"
     #  fi

     #  exec niri-session
     #'')
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.variables.EDITOR = "vim";
  fonts.packages = with pkgs; [
    fira-code
    nerd-fonts.fira-code
  ];

  system.stateVersion = "25.11";
}
