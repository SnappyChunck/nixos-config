{ config, pkgs, lib, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.variables = ["--all"];

    config = rec {
      modifier = "Mod4"; # Super key

      terminal = "kitty";

      window.titlebar = false;

      # Cursor (replaces your environment {} block)
      seat."*".xcursor_theme = "Bibata-Modern-Classic 24";

      # Mouse input
      input."type:pointer" = {
        accel_profile = "flat";
      };
      input."type:keyboard" = {
        xkb_layout = "de";
      };

      # Outputs (your DP-2 and DP-1)
      output = {
        "DP-2" = {
          mode = "2560x1440@180.063Hz";
          scale = "1";
          pos = "-18 -471"; # sway uses `pos` not `position`
        };
        "DP-1" = {
          mode = "2560x1440@180.063Hz";
          scale = "1";
          pos = "2542 -471";
        };
      };

      # Gaps
      gaps = {
        inner = 6;
      };

      # Borders (sway has no gradient support without SwayFX)
      colors = {
        focused = {
          border = "#7aa2f7";
          background = "#7aa2f7";
          text = "#ffffff";
          indicator = "#7aa2f7";
          childBorder = "#7aa2f7";
        };
        unfocused = {
          border = "#595959aa";
          background = "#222222";
          text = "#888888";
          indicator = "#595959";
          childBorder = "#595959";
        };
      };

      # Bars (using your existing waybar)
      bars = []; # empty = no built-in bar, waybar handles it

      # Startup
      startup = [
        { command = "swaybg -i /etc/nixos/wallpapers/sunset-lake.png -m fill"; }
        { command = "waybar"; }
        { command = "autotiling-rs"; }
      ];

      # Floating windows
      floating.criteria = [
        { app_id = "impala"; }
        { app_id = "btop"; }
        { app_id = "pavucontrol"; }
        { app_id = "bluetui"; }
        { app_id = "firefox"; title = "Picture-in-Picture"; }
      ];

      # Keybindings
      # lib.mkOptionDefault preserves sway's defaults and adds yours on top.
      # If you want ONLY your binds, use `keybindings = { ... }` without mkOptionDefault.
      keybindings = lib.mkOptionDefault {
        # Apps
        "${modifier}+Return" = "exec kitty";
        "${modifier}+Space" = "exec walker";
        "${modifier}+Shift+v" = "focus mode_toggle";
        "${modifier}+space"   = null;
        "${modifier}+Shift+b" = "exec pkill waybar; waybar &";

        # Window management
        "${modifier}+w" = "kill";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+v" = "floating toggle";

        # Focus movement
        "${modifier}+Left"  = "focus left";
        "${modifier}+Down"  = "focus down";
        "${modifier}+Up"    = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+h"     = "focus left";
        "${modifier}+j"     = "focus down";
        "${modifier}+k"     = "focus up";
        "${modifier}+l"     = "focus right";

        # Move windows
        "${modifier}+Ctrl+Left"  = "move left";
        "${modifier}+Ctrl+Down"  = "move down";
        "${modifier}+Ctrl+Up"    = "move up";
        "${modifier}+Ctrl+Right" = "move right";
        "${modifier}+Ctrl+h"     = "move left";
        "${modifier}+Ctrl+j"     = "move down";
        "${modifier}+Ctrl+k"     = "move up";
        "${modifier}+Ctrl+l"     = "move right";

        # Focus monitors
        "${modifier}+Shift+Left"  = "focus output left";
        "${modifier}+Shift+Down"  = "focus output down";
        "${modifier}+Shift+Up"    = "focus output up";
        "${modifier}+Shift+Right" = "focus output right";
        "${modifier}+Shift+h"     = "focus output left";
        "${modifier}+Shift+j"     = "focus output down";
        "${modifier}+Shift+k"     = "focus output up";
        "${modifier}+Shift+l"     = "focus output right";

        # Move to monitor
        "${modifier}+Shift+Ctrl+Left"  = "move container to output left";
        "${modifier}+Shift+Ctrl+Down"  = "move container to output down";
        "${modifier}+Shift+Ctrl+Up"    = "move container to output up";
        "${modifier}+Shift+Ctrl+Right" = "move container to output right";
        "${modifier}+Shift+Ctrl+h"     = "move container to output left";
        "${modifier}+Shift+Ctrl+j"     = "move container to output down";
        "${modifier}+Shift+Ctrl+k"     = "move container to output up";
        "${modifier}+Shift+Ctrl+l"     = "move container to output right";

        # Workspaces
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+Ctrl+1" = "move container to workspace number 1";
        "${modifier}+Ctrl+2" = "move container to workspace number 2";
        "${modifier}+Ctrl+3" = "move container to workspace number 3";
        "${modifier}+Ctrl+4" = "move container to workspace number 4";
        "${modifier}+Ctrl+5" = "move container to workspace number 5";
        "${modifier}+Ctrl+6" = "move container to workspace number 6";
        "${modifier}+Ctrl+7" = "move container to workspace number 7";
        "${modifier}+Ctrl+8" = "move container to workspace number 8";
        "${modifier}+Ctrl+9" = "move container to workspace number 9";

        # Workspace up/down (your u/i/page binds)
        "${modifier}+Page_Down"      = "workspace next";
        "${modifier}+Page_Up"        = "workspace prev";
        "${modifier}+u"              = "workspace next";
        "${modifier}+i"              = "workspace prev";
        "${modifier}+Ctrl+Page_Down" = "move container to workspace next";
        "${modifier}+Ctrl+Page_Up"   = "move container to workspace prev";
        "${modifier}+Ctrl+u"         = "move container to workspace next";
        "${modifier}+Ctrl+i"         = "move container to workspace prev";

        # Resize (approximate niri's +/- 10%)
        "${modifier}+minus" = "resize shrink width 100px";
        "${modifier}+equal" = "resize grow width 100px";
        "${modifier}+Shift+minus" = "resize shrink height 100px";
        "${modifier}+Shift+equal" = "resize grow height 100px";

        # Audio (wpctl like your niri config)
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        "XF86AudioMute"        = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute"     = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        # Media
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";

        # Brightness
        "XF86MonBrightnessUp"   = "exec brightnessctl --class=backlight set +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl --class=backlight set 10%-";

        # Quit
        "${modifier}+Shift+e" = "exec swaymsg exit";
        "Ctrl+Alt+Delete"     = "exec swaymsg exit";

        "${modifier}+Shift+p" = "exec swaymsg output '*' dpms off";
      };

      # Screen capture privacy (block-out-from equivalent doesn't exist in sway,
      # but you can prevent apps from screensharing using portal config)
    };

    extraConfig = ''
      # Include NixOS-generated sway config (critical for portals/dbus)
      include /etc/sway/config.d/*

      # Corner radius requires SwayFX — leave at 0 if using stock sway
      # default_border pixel 4

      # KeePassXC / Secrets: no direct equivalent of block-out-from in stock sway
      # Use pipewire portal settings to restrict screen capture instead
    '';
  };
}
