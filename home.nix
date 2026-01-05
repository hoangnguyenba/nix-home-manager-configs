{ config, pkgs, lib, system, username, ghostty, ... }:
let
  # Detect if running on macOS
  isDarwin = builtins.match ".*-darwin" system != null;
  # Detect if running on Linux
  isLinux = builtins.match ".*-linux" system != null;
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should manage
  # Username is inherited from flake.nix
  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.05";

  # The home.packages option allows you to install Nix packages into your environment
  home.packages = 
    let
      commonPackages = with pkgs; [
        # aws cli
        awscli2
        # aws-sam-cli
        ssm-session-manager-plugin

        # devops
        terraform

        # sql
        mysql84

        # PHP 8.4 and tools
        php84
        php84Packages.composer

        # Node.js 24
        nodejs_24
        pnpm

        # python
        python312
        python312Packages.pip

        # Add more packages here
        go

        # cli tools
        zoxide
        fzf
        eza
        lazygit
        bat
        gh

        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.meslo-lg
      ];

      linuxPackages = with pkgs; [
        dconf
        wofi
        # Clipboard manager that works with Pantheon/Mutter
        copyq  # Works on both X11 and Wayland
        wl-clipboard  # Keep this for CLI clipboard operations

        # Clipboard menu script - references external file
        (pkgs.writeShellScriptBin "clipmenu-wofi" (builtins.readFile ./scripts/clipmenu-wofi.sh))
      ];
    in
    commonPackages ++ (lib.optionals isLinux linuxPackages);

  # Home Manager can also manage your environment variables
  home.sessionVariables = {
    # EDITOR = "vim";
    # PHP configuration
    PHP_INI_SCAN_DIR = "$HOME/.config/php";
  };

  # Linux-specific configurations
  home.file = lib.mkIf isLinux {
    ".config/wofi/style.css".source = ./config/wofi/style.css;
  };

  # Add after your home.file sections
  dconf.settings = lib.mkIf isLinux {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Clipboard Manager";
      command = "clipmenu-wofi";
      binding = "<Super>v";
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}