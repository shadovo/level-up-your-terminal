#!/usr/bin/env bash
# Setup a new macOS machine for development
# Run with: bash install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_step() {
  echo ""
  echo "===> $1"
}

# ─── Manual steps ────────────────────────────────────────────────────────────
echo ""

install_if_missing() {
  local name="$1"
  local app_path="$2"
  local url="$3"
  if [[ -d "$app_path" ]]; then
    echo "  ✓ $name is already installed – skipping."
  else
    read -r -p "  $name not found. Press Enter to open the download page..."
    open "$url"
    read -r -p "  Once $name is installed, press Enter to continue..."
  fi
}

print_step "Checking required applications..."
install_if_missing "Google Chrome"       "/Applications/Google Chrome.app"        "https://www.google.com/chrome/"
install_if_missing "Ghostty"             "/Applications/Ghostty.app"              "https://ghostty.org/download"
install_if_missing "Visual Studio Code"  "/Applications/Visual Studio Code.app"   "https://code.visualstudio.com/"

# ─── Xcode Command Line Tools ─────────────────────────────────────────────────
print_step "Installing Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "Follow the on-screen prompts to complete installation, then re-run this script."
  exit 0
else
  echo "Already installed."
fi

# ─── Homebrew ─────────────────────────────────────────────────────────────────
print_step "Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Already installed."
fi

# Initialize the Homebrew environment (sets HOMEBREW_PREFIX, updates PATH, etc.)
# We can't rely on `brew` being on PATH after a fresh install, so we locate the
# binary by checking both the Apple Silicon and Intel default locations.
BREW_BIN="$(command -v brew 2>/dev/null || true)"
if [[ -z "$BREW_BIN" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_BIN="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_BIN="/usr/local/bin/brew"
  else
    echo "Homebrew was not found after installation. Exiting."
    exit 1
  fi
fi
eval "$("$BREW_BIN" shellenv)"

# ─── Nerd Font ────────────────────────────────────────────────────────────────
print_step "Installing Geist Mono Nerd Font..."
brew install --cask font-geist-mono-nerd-font

# ─── CLI Tools ────────────────────────────────────────────────────────────────
print_step "Installing CLI tools..."
brew install \
  starship \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  tldr \
  bat \
  fd \
  ripgrep \
  fzf \
  jq \
  git-delta \
  tree \
  ffmpeg \
  imagemagick \
  vim \
  nvm \
  pnpm \
  htop

# Install fzf key bindings and fuzzy completion
print_step "Setting up fzf key bindings..."
"$HOMEBREW_PREFIX/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish

# ─── .zshrc ───────────────────────────────────────────────────────────────────
print_step "Installing .zshrc..."
if [[ -L "$HOME/.zshrc" ]]; then
  echo "  Symlink already exists: ~/.zshrc"
elif [[ -f "$HOME/.zshrc" ]]; then
  echo "  ~/.zshrc already exists – skipping to avoid overwriting."
  echo "  To apply manually, remove it and re-run: rm ~/.zshrc"
else
  ln -s "$SCRIPT_DIR/configs/.zshrc" "$HOME/.zshrc"
  echo "  Symlinked to ~/.zshrc"
fi

# ─── nvm dir ──────────────────────────────────────────────────────────────────
mkdir -p "$HOME/.nvm"

# ─── zsh_functions ────────────────────────────────────────────────────────────
print_step "Installing zsh functions..."
if [[ -L "$HOME/.zsh_functions" ]]; then
  echo "  Symlink already exists: ~/.zsh_functions"
elif [[ -d "$HOME/.zsh_functions" ]]; then
  echo "  ~/.zsh_functions already exists as a directory – skipping."
  echo "  To apply manually, remove it and re-run: rm -rf ~/.zsh_functions"
else
  ln -s "$SCRIPT_DIR/.zsh_functions" "$HOME/.zsh_functions"
  echo "  Symlinked to ~/.zsh_functions"
fi

# ─── Git config ───────────────────────────────────────────────────────────────
print_step "Installing git config..."
if [[ -L "$HOME/.gitconfig" ]]; then
  echo "  Symlink already exists: ~/.gitconfig"
elif [[ -f "$HOME/.gitconfig" ]]; then
  echo "  ~/.gitconfig already exists – skipping to avoid overwriting."
  echo "  To apply manually, remove it and re-run: rm ~/.gitconfig"
else
  ln -s "$SCRIPT_DIR/configs/.gitconfig" "$HOME/.gitconfig"
  echo "  Symlinked to ~/.gitconfig"
fi

print_step "Setting git user details..."
read -r -p "  Enter your git user.name: " git_name
read -r -p "  Enter your git user.email: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"

# ─── SSH key + commit signing ─────────────────────────────────────────────────────
print_step "Setting up SSH key for commit signing..."
if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
  echo "  SSH key already exists at ~/.ssh/id_ed25519 – skipping generation."
else
  ssh-keygen -t ed25519 -C "$git_email" -f "$HOME/.ssh/id_ed25519"
  echo ""
  echo "  Add this public key to GitHub (Settings → SSH and GPG keys):"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo ""
  read -r -p "  Press Enter once you've added the key to GitHub..."
fi

# Register public key in allowed_signers for git commit signature verification
if [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
  PUB_KEY=$(cat "$HOME/.ssh/id_ed25519.pub")
  ALLOWED_SIGNERS="$HOME/.ssh/allowed_signers"
  if ! grep -qF "$PUB_KEY" "$ALLOWED_SIGNERS" 2>/dev/null; then
    echo "$git_email namespaces=\"git\" $PUB_KEY" >> "$ALLOWED_SIGNERS"
    echo "  Added key to ~/.ssh/allowed_signers"
  else
    echo "  Key already in ~/.ssh/allowed_signers – skipping."
  fi
fi

# ─── Vim config ────────────────────────────────────────────────────────────────
print_step "Installing vim config..."
if [[ -L "$HOME/.vimrc" ]]; then
  echo "  Symlink already exists: ~/.vimrc"
elif [[ -f "$HOME/.vimrc" ]]; then
  echo "  ~/.vimrc already exists – skipping to avoid overwriting."
  echo "  To apply manually, remove it and re-run: rm ~/.vimrc"
else
  ln -s "$SCRIPT_DIR/configs/.vimrc" "$HOME/.vimrc"
  echo "  Symlinked to ~/.vimrc"
fi

# Create vim undo directory (required by .vimrc undofile setting)
mkdir -p "$HOME/.vim/undodir"

# ─── Ghostty config ───────────────────────────────────────────────────────────
print_step "Installing Ghostty config..."
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_CONFIG_DIR"
if [[ -L "$GHOSTTY_CONFIG_DIR/config" ]]; then
  echo "  Symlink already exists: $GHOSTTY_CONFIG_DIR/config"
elif [[ -f "$GHOSTTY_CONFIG_DIR/config" ]]; then
  echo "  Ghostty config already exists – skipping to avoid overwriting."
  echo "  To apply manually, remove it and re-run: rm $GHOSTTY_CONFIG_DIR/config"
else
  ln -s "$SCRIPT_DIR/configs/ghostty" "$GHOSTTY_CONFIG_DIR/config"
  echo "  Symlinked to $GHOSTTY_CONFIG_DIR/config"
fi
# ─── Starship config ───────────────────────────────────────────────────────────────
print_step "Installing Starship config..."
STARSHIP_CONFIG_DIR="$HOME/.config"
mkdir -p "$STARSHIP_CONFIG_DIR"
if [[ -L "$STARSHIP_CONFIG_DIR/starship.toml" ]]; then
  echo "  Symlink already exists: $STARSHIP_CONFIG_DIR/starship.toml"
elif [[ -f "$STARSHIP_CONFIG_DIR/starship.toml" ]]; then
  echo "  Starship config already exists – skipping to avoid overwriting."
  echo "  To apply manually, remove it and re-run: rm $STARSHIP_CONFIG_DIR/starship.toml"
else
  ln -s "$SCRIPT_DIR/configs/starship.toml" "$STARSHIP_CONFIG_DIR/starship.toml"
  echo "  Symlinked to $STARSHIP_CONFIG_DIR/starship.toml"
fi
# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "✓ Setup complete! Restart your terminal (or run 'source ~/.zshrc') to apply all changes."


