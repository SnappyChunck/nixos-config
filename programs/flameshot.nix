{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        # Save Path
        savePath = "/home/fio/Pictures/Screenshots";
        # Tray
        disabledTrayIcon = true;
        # Greeting message   
        showStartupLaunchMessage = false;
        # Default file extension for screenshots (.png by default)
        saveAsFileExtension = ".png";
        # Desktop notifications
        showDesktopNotification = true;
        # Notification for cancelled screenshot
        showAbortNotification = false;
        # Whether to show the info panel in the center in GUI mode
        showHelp = true;
        # Whether to show the left side button in GUI mode
        showSidePanelButton = true;


        # Color Customization
        uiColor = "#1a1b26";
        contrastUiColor = "#7aa2f7";
        drawColor = "#1a1b26";

        # For Wayland (Install Grim seperately)
        useGrimAdapter = true;
        # Stops warnings for using Grim
        disabledGrimWarning = true;
      };
    };
  };
}
