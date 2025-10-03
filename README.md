# Nix Home Manager Configuration

A flake-based Home Manager configuration for managing development environments on Arch Linux (or any Linux distribution).

## 📦 What's Included

- **PHP 8.4** with Composer
- **Node.js 22** with npm
- Declarative package management
- Reproducible development environment

## 🚀 Installation

### Step 1: Install Nix Package Manager

Install Nix with the daemon (multi-user installation):

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

After installation, restart your terminal or source the nix profile:

```bash
source /etc/profile.d/nix.sh
```

Verify installation:

```bash
nix --version
```

### Step 2: Enable Flakes

Create Nix configuration directory and enable experimental features:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

**Alternative**: Enable system-wide (requires sudo):

```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

Restart the Nix daemon:

```bash
sudo systemctl restart nix-daemon
```

### Step 3: Clone This Repository

Clone this repository to your home config directory:

```bash
git clone git@github.com:hoangnguyenba/nix-home-manager-configs.git ~/.config/home-manager
cd ~/.config/home-manager
```

**Important**: Update the configuration files with your username:

1. Edit `flake.nix` - replace `hoang` in `homeConfigurations.hoang`
2. Edit `home.nix` - replace `hoang` in `home.username` and `home.homeDirectory`

```bash
# Edit the files
nano flake.nix
nano home.nix
```

### Step 4: Bootstrap Home Manager

Run the initial installation (replace `YOUR_USERNAME` with your actual username):

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#YOUR_USERNAME
```

For example, if your username is `hoang`:

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#hoang
```

This will:
- Download and install Home Manager
- Install all packages defined in `home.nix`
- Set up the `home-manager` command for future use

### Step 5: Verify Installation

Check that packages are installed:

```bash
php --version      # Should show PHP 8.4.x
node --version     # Should show v22.x.x
composer --version
npm --version
```

## 📁 Configuration Files

This repository includes two main configuration files:

### `flake.nix`

Main flake configuration that defines inputs and outputs.

**Important**: Update `hoang` to your username in the `homeConfigurations` line:

```nix
homeConfigurations.YOUR_USERNAME = home-manager.lib.homeManagerConfiguration {
```

### `home.nix`

Home Manager module that defines packages and settings.

**Important**: Update these values to match your system:
- `home.username = "YOUR_USERNAME";`
- `home.homeDirectory = "/home/YOUR_USERNAME";`

The default configuration includes:
- PHP 8.4 with Composer
- Node.js 22 with npm
- Basic session variables

## 🔧 Usage

### Applying Changes

After modifying `home.nix`, apply changes:

```bash
home-manager switch --flake ~/.config/home-manager#hoang
```

### Adding an Alias (Recommended)

Add to your `~/.bashrc` or `~/.zshrc` (replace `YOUR_USERNAME` with your actual username):

```bash
alias hms='home-manager switch --flake ~/.config/home-manager#YOUR_USERNAME'
```

Then reload:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

Now you can simply run:

```bash
hms
```

### Common Commands

| Command | Description |
|---------|-------------|
| `hms` (or full command) | Apply configuration changes |
| `nix flake update` | Update flake inputs (nixpkgs, home-manager) |
| `home-manager generations` | List previous generations |
| `home-manager switch --rollback` | Rollback to previous generation |
| `nix flake show` | Show flake outputs |
| `nix search nixpkgs <package>` | Search for packages |

### Updating Packages

1. Update flake inputs:
   ```bash
   cd ~/.config/home-manager
   nix flake update
   ```

2. Apply changes:
   ```bash
   hms
   ```

### Adding More Packages

Edit `home.nix` and add packages to the `home.packages` list:

```nix
home.packages = with pkgs; [
  php84
  php84Packages.composer
  nodejs_22
  
  # Add more packages here
  python312
  go
  rustc
  cargo
  docker-compose
  git
  vim
];
```

Then run `hms` to apply.

### Rollback

If something goes wrong, rollback to the previous generation:

```bash
home-manager generations
home-manager switch --flake ~/.config/home-manager#YOUR_USERNAME --rollback
```

## 🎯 Key Concepts

### Why packages don't disappear on reboot

- Nix stores packages in `/nix/store/` with unique hashes
- Home Manager creates symlinks in `~/.nix-profile/` pointing to these packages
- These are regular files on disk - they persist across reboots
- You only need to run `hms` when **changing your configuration**, not on every boot

### Generations

Home Manager keeps track of previous configurations (generations). You can always rollback to any previous state.

### Flakes

Flakes provide:
- Reproducible builds (locked dependencies in `flake.lock`)
- Clear input/output structure
- Better caching and performance
- Modern Nix workflow

## 🔍 Troubleshooting

### Command not found: home-manager

If after installation `home-manager` is not found:

```bash
# Make sure ~/.nix-profile/bin is in your PATH
export PATH="$HOME/.nix-profile/bin:$PATH"

# Add to ~/.bashrc to make it permanent
echo 'export PATH="$HOME/.nix-profile/bin:$PATH"' >> ~/.bashrc
```

### Flake errors

If you get "flake does not provide attribute" errors:

1. Check your username matches in both `flake.nix` and `home.nix`
2. Ensure the repository is properly cloned with git tracking

### Build failures

If packages fail to build:

```bash
# Update flake inputs
nix flake update

# Try building again
hms
```

## 📚 Resources

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)

## 📝 License

This configuration is provided as-is for personal use.