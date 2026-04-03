{ config, pkgs, system, username, ghostty, ... }:
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
    # aws-sam-cli
    ssm-session-manager-plugin

    # devops
    terraform

    # sql
    mysql84

    # PHP 8.4 and tools
    (php84.withExtensions ({ all, ... }: with all; [
      grpc
      protobuf 
      
      opcache
      pdo_mysql
      mbstring
      filter
      openssl
      zlib
    ]))
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

  # Home Manager can also manage your environment variables
  home.sessionVariables = {
    # EDITOR = "vim";
    # PHP configuration
    PHP_INI_SCAN_DIR = "$HOME/.config/php";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}