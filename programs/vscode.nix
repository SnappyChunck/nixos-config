{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;

    #package = pkgs.vscode.fhsWithPackages (ps: with ps; [
    #  platformio
    #]);

    profiles.default.extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      #platformio.platformio
      ms-vscode.cpptools-extension-pack
    ];

    #userSettings = {
    #  "platformio-ide.useBuiltinPIOCore" = false;
    #};
  };
}
