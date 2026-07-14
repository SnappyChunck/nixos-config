{ inputs, pkgs, ... }:

let
  mkExtensions = builtins.mapAttrs (
    _: slug: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
      installation_mode = "force_installed";
    }
  );
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;

      ExtensionSettings = mkExtensions {
        # uBlock Origin
        "uBlock0@raymondhill.net" = "ublock-origin";
        # Dark Reader
        "addon@darkreader.org" = "darkreader";
        # Enhancer for YouTube
        "enhancerforyoutube@maximerf.addons.mozilla.org" = "enhancer-for-youtube";
        # KeePassXC-Browser
        "keepassxc-browser@keepassxc.org" = "keepassxc-browser";
        # SponsorBlock
        "sponsorBlocker@ajay.app" = "sponsorblock";
        # Unhook
        "myallychou@gmail.com" = "youtube-recommended-videos";
        # Claude Counter
        "{cf7799c8-d878-41ff-8005-167bee7ab3d6}" = "claude-counter";
      };
    };

    profiles.default = {
      sine.enable = true;

      settings = {
        "browser.tabs.groups.enabled" = true;

        "zen.view.use-single-toolbar" = false;
        "zen.tabs.vertical" = true;

        "browser.startup.page" = 3;
        "browser.tabs.warnOnClose" = false;
        "browser.warnOnQuit" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;

        "browser.tabs.allow_transparent_browser" = true;

        "zen.widget.linux.transparency" = false;

        "nebula-disable-container-styling" = true;

        "sine.engine.auto-update" = false;

        "zen.window-sync.enabled" = false;
      };
    };
  };
}
