{ config, pkgs, system, username, ... }:

let
  # Detect if running on macOS
  isDarwin = builtins.match ".*-darwin" system != null;
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
  home.packages = with pkgs; [
    # aws cli
    awscli2
    aws-sam-cli
    ssm-session-manager-plugin

    # devops
    terraform

    # sql
    mysql84

    # PHP 8.4 and tools
    php84
    php84Packages.composer
    
    # Node.js 22
    nodejs_22
    pnpm

    # python
    python312
    
    # Add more packages here
    go
  ];

  # Home Manager can also manage your environment variables
  home.sessionVariables = {
    # EDITOR = "vim";
    # PHP configuration
    PHP_INI_SCAN_DIR = "$HOME/.config/php";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}