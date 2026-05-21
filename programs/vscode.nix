{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      ms-vscode.cpptools-extension-pack
      geequlim.godot-tools
      ms-dotnettools.csdevkit
      ms-dotnettools.vscode-dotnet-runtime
      jnoortheen.nix-ide
      github.vscode-github-actions
      ms-python.python
      #kevinrose.vsc-python-indent
      #bilelmoussaoui.flatpak-vscode
      #dsobotta.godot-rust-vscode
    ];

    profiles.default.userSettings = {
      "godotTools.editorPath.godot4" = "/etc/profiles/per-user/fio/bin/godot4.6-mono";

      "workbench.secondarySideBar.defaultVisibility" = "hidden";

      "chat.viewSessions.enabled" = true;

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = ["nixfmt"];
          };
          "options" = {
            "home-manager" = {
              "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.nixos.options.home-manager.users.type.functor.wrapped";
            };
          };
        };
      };
    };
    
  };
}
