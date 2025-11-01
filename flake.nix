{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # ===== CHANGE THIS TO YOUR USERNAME =====
      username = "hoang";
      # ========================================
      
      # Define systems
      systems = {
        linux = "x86_64-linux";
        macos-intel = "x86_64-darwin";
        macos-arm = "aarch64-darwin";
      };
      
      # Helper function to create home configuration for a system
      mkHomeConfiguration = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit system username;
          };
        };
    in {
      # Linux (x86_64)
      homeConfigurations.linux = mkHomeConfiguration systems.linux;
      
      # macOS Intel (x86_64)
      homeConfigurations.macos-intel = mkHomeConfiguration systems.macos-intel;
      
      # macOS Apple Silicon (ARM)
      homeConfigurations.macos-arm = mkHomeConfiguration systems.macos-arm;
    };
}