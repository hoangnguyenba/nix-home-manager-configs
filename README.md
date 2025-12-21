# Nix Home Manager Configuration

A cross-platform flake-based Home Manager configuration for managing development environments on **Linux** and **macOS**.

## 📦 What's Included

- **PHP 8.4** with Composer
- **Node.js 22** with npm
- **Python 3.12**
- **Go**
- **AWS CLI v2** with SAM CLI and SSM Session Manager Plugin
- **Terraform** for infrastructure as code
- Declarative package management
- Reproducible development environment across platforms

## 🚀 Installation

### Step 1: Install Nix Package Manager

Installation steps differ between Linux and macOS.

#### **For Linux**

You have two options – pick the one that fits your workflow.

**Option A – Multi-user (daemon, recommended for shared machines)**  

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```

**Option B – Single-user (no daemon, simplest for personal laptops)**  

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
```

After installation, restart your terminal or source the nix profile:

```bash
source /etc/profile.d/nix.sh
```

#### **For macOS**

On macOS, use the multi-user installation (recommended):

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```

The installer will handle macOS-specific setup automatically.

After installation, restart your terminal or source the nix profile:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

#### **Verify Installation**

```bash
nix --version
```

### Step 2: Enable Flakes

Create Nix configuration directory and enable experimental features:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

**Alternative for Linux**: Enable system-wide (requires sudo):

```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

**For macOS**: Restart the Nix daemon:

```bash
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

**For Linux**: Restart the Nix daemon:

```bash
sudo systemctl restart nix-daemon
```

### Step 3: Clone This Repository

Clone this repository to your home config directory:

```bash
git clone git@github.com:hoangnguyenba/nix-home-manager-configs.git ~/.config/home-manager
cd ~/.config/home-manager
```

### Step 4: Configure Your Username

**⚠️ IMPORTANT**: Edit only ONE file to set your username:

```bash
nano flake.nix
```

Find this section near the top:

```nix
# ===== CHANGE THIS TO YOUR USERNAME =====
username = "hoang";
# ========================================
```

Change `"hoang"` to your actual username, then save the file. That's it! The username will automatically be used everywhere.

### Step 5: Bootstrap Home Manager

Run the initial installation using the appropriate configuration for your system:

#### **For Linux (x86_64)**

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#linux
```

#### **For macOS Intel (x86_64)**

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#macos-intel
```

#### **For macOS Apple Silicon (ARM/M1/M2/M3)**

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#macos-arm
```

**Example**: If you're on macOS Apple Silicon:

```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#macos-arm
```

This will:
- Download and install Home Manager
- Install all packages defined in `home.nix`
- Set up the `home-manager` command for future use

### Step 6: Verify Installation

Check that packages are installed:

```bash
php --version      # Should show PHP 8.4.x
node --version     # Should show v22.x.x
composer --version
npm --version
python --version   # Should show Python 3.12.x
go version
```

## 📁 Configuration Files

This repository includes two main configuration files:

### `flake.nix`

Main flake configuration that defines inputs and outputs for multiple platforms.

**⭐ This is the ONLY file you need to edit for username configuration!**

Look for this section at the top:

```nix
# ===== CHANGE THIS TO YOUR USERNAME =====
username = "hoang";
# ========================================
```

Change the username once here, and it will be used throughout the entire configuration automatically.

### `home.nix`

Home Manager module that defines packages and settings. 

**✨ No editing needed!** The username and home directory are automatically inherited from `flake.nix`.

## 🔧 Usage

### Applying Changes

After modifying `home.nix`, apply changes using your system-specific configuration:

**Linux:**
```bash
home-manager switch --flake ~/.config/home-manager#linux
```

**macOS Intel:**
```bash
home-manager switch --flake ~/.config/home-manager#macos-intel
```

**macOS Apple Silicon:**
```bash
home-manager switch --flake ~/.config/home-manager#macos-arm
```

### Adding an Alias (Recommended)

Add to your `~/.bashrc` or `~/.zshrc`:

**For Linux:**
```bash
alias hms='home-manager switch --flake ~/.config/home-manager#linux'
```

**For macOS Intel:**
```bash
alias hms='home-manager switch --flake ~/.config/home-manager#macos-intel'
```

**For macOS Apple Silicon:**
```bash
alias hms='home-manager switch --flake ~/.config/home-manager#macos-arm'
```

Then reload:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

Now you can simply run:

```bash
hms
```

### All additional config

bash
```bash
. /home/hoang/.nix-profile/etc/profile.d/nix.sh

alias hms='home-manager switch --flake ~/.config/home-manager#linux'

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PATH="$HOME/.npm-global/bin:$PATH"

eval "$(zoxide init bash)"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first -l'
alias la='eza --icons --group-directories-first -la'
alias lt='eza --icons --group-directories-first --tree'
alias lsl='eza --icons --group-directories-first -lah'
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

### Platform-Specific Packages (Advanced)

If you need different packages on different platforms, you can use conditionals in `home.nix`:

```nix
home.packages = with pkgs; [
  # Common packages
  php84
  nodejs_22
] ++ (if isDarwin then [
  # macOS-only packages
] else [
  # Linux-only packages
]);
```

### Rollback

If something goes wrong, rollback to the previous generation:

```bash
home-manager generations
home-manager switch --flake ~/.config/home-manager#PLATFORM --rollback
```

Replace `PLATFORM` with your platform (e.g., `linux`, `macos-arm`, `macos-intel`).

## 🖥️ Platform Support

This configuration supports:
- ✅ **Linux (x86_64)** - Arch, Ubuntu, Debian, Fedora, etc.
- ✅ **macOS Intel (x86_64)** - Intel-based Macs
- ✅ **macOS Apple Silicon (aarch64)** - M1, M2, M3, M4 Macs

## 🎯 Quick Start Summary

1. **Install Nix** (see Step 1 above)
2. **Enable Flakes** (see Step 2 above)
3. **Clone this repo** to `~/.config/home-manager`
4. **Edit ONE line** in `flake.nix` - change `username = "hoang"` to your username
5. **Run bootstrap command** for your platform (see Step 5 above)
6. **Done!** All your dev tools are installed

## 📚 Resources

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)
- [Nix on macOS](https://nixos.org/manual/nix/stable/installation/installing-binary.html#macos-installation)

## 🐛 Troubleshooting

### macOS: "command not found: home-manager" after installation

Make sure you've sourced the Nix profile:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

Add this to your `~/.zshrc` or `~/.bash_profile` to make it permanent.

### macOS: Permission denied errors

Ensure Nix daemon is running:

```bash
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

### Wrong system detected

Check your system architecture:

```bash
uname -m
```

- `x86_64` = Intel (use `@linux` or `@macos-intel`)
- `aarch64` or `arm64` = Apple Silicon (use `@macos-arm`)

## 📝 License

This configuration is provided as-is for personal use.