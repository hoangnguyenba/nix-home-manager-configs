{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "hoang";  # Replace with your actual username
  home.homeDirectory = "/home/hoang";  # Replace with your home directory

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.05";

  # The home.packages option allows you to install Nix packages into your environment
  home.packages = with pkgs; [
    # PHP 8.4 and tools
    php84
    php84Packages.composer
    
    # Node.js 22
    nodejs_22
    
    # # Common development utilities
    # git
    # curl
    # wget
    # vim
    # neovim
    # htop
    # tree
    # jq
    
    # # Build tools
    # gcc
    # gnumake
    # cmake
    
    # # Modern CLI tools
    # ripgrep      # Fast grep alternative
    # fd           # Fast find alternative
    # bat          # Better cat with syntax highlighting
    # fzf          # Fuzzy finder
    # eza          # Modern ls replacement
    # bottom       # System monitor
    
    # # Development tools
    # lazygit      # Terminal UI for git
    # delta        # Better git diff
  ];

  # Home Manager can also manage your environment variables
  home.sessionVariables = {
    # EDITOR = "vim";
    # PHP configuration
    PHP_INI_SCAN_DIR = "$HOME/.config/php";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Git configuration
  # programs.git = {
  #   enable = true;
  #   userName = "Your Name";
  #   userEmail = "your.email@example.com";
  #   extraConfig = {
  #     init.defaultBranch = "main";
  #     pull.rebase = false;
  #     core.editor = "vim";
  #   };
  #   delta = {
  #     enable = true;
  #     options = {
  #       navigate = true;
  #       light = false;
  #       side-by-side = true;
  #     };
  #   };
  # };

  # Bash configuration
  # programs.bash = {
  #   enable = true;
  #   shellAliases = {
  #     ll = "eza -la";
  #     ls = "eza";
  #     ".." = "cd ..";
  #     "..." = "cd ../..";
  #     update = "cd ~/.config/home-manager && nix flake update && home-manager switch --flake .";
  #     hms = "home-manager switch --flake ~/.config/home-manager";
  #   };
  #   bashrcExtra = ''
  #     # Custom bash configuration
  #     export PATH="$HOME/.nix-profile/bin:$PATH"
      
  #     # Node.js version info
  #     if command -v node &> /dev/null; then
  #       echo "Node.js: $(node --version)"
  #     fi
      
  #     # PHP version info
  #     if command -v php &> /dev/null; then
  #       echo "PHP: $(php --version | head -n 1)"
  #     fi
  #   '';
  # };

  # Direnv for per-directory development environments
  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  #   enableBashIntegration = true;
  # };

  # Starship prompt (optional, modern shell prompt)
  # programs.starship = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   settings = {
  #     add_newline = true;
  #     character = {
  #       success_symbol = "[➜](bold green)";
  #       error_symbol = "[➜](bold red)";
  #     };
  #     nodejs = {
  #       format = "via [$symbol($version )]($style)";
  #       detect_files = ["package.json" ".node-version"];
  #     };
  #     php = {
  #       format = "via [$symbol($version )]($style)";
  #       detect_files = ["composer.json" ".php-version"];
  #     };
  #   };
  # };

  # Better file management
  # programs.eza = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   git = true;
  #   icons = true;
  # };

  # Modern terminal file manager (optional)
  # programs.yazi = {
  #   enable = true;
  #   enableBashIntegration = true;
  # };
}