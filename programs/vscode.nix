{ pkgs, inputs, ... }:
{
  programs.vscode = {
    enable = true;

    profiles.default.extensions =
      (with pkgs.vscode-extensions; [
        ms-dotnettools.csdevkit
        ms-dotnettools.vscode-dotnet-runtime
      ]) ++
      (with pkgs.vscode-marketplace; [
        enkia.tokyo-night
        ms-vscode.cpptools-extension-pack
        geequlim.godot-tools
        jnoortheen.nix-ide
        github.vscode-github-actions
        ms-python.python

        svelte.svelte-vscode
        ardenivanov.svelte-intellisense

        kevinrose.vsc-python-indent
        bilelmoussaoui.flatpak-vscode
        dsobotta.godot-rust-vscode

        gruntfuggly.todo-tree
        fill-labs.dependi
        dustypomerleau.rust-syntax
      ]);

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
