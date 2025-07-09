#!/bin/bash

echo "Starting Homebrew and common tools installation script..."
echo "--------------------------------------------------------"

# Check if Homebrew is already installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo "Homebrew installed successfully!"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Error: Homebrew installation failed. Please check the output above."
        exit 1
    fi
else
    echo "Homebrew is already installed. Updating it to ensure it's current..."
    brew update
fi

echo "--------------------------------------------------------"

PACKAGES_TO_INSTALL=(
  bat
  fzf
  go
  jq
  neovim
  node
  reattach-to-user-namespace # tmux clipboard support
  stow
  the_silver_searcher
  tmux
)

echo "Installing common Homebrew packages..."

for package in "${PACKAGES_TO_INSTALL[@]}"; do
    if brew list --formula | grep -q "^${package}\$"; then
        echo "  '$package' is already installed. Skipping."
    else
        echo "  Installing '$package'..."
        brew install "$package"
        if [ $? -ne 0 ]; then
            echo "  Warning: Failed to install '$package'. Continuing with other packages."
        fi
    fi
done

echo "Common Homebrew packages installation complete."
echo "--------------------------------------------------------"

CASKS_TO_INSTALL=(
    google-cloud-sdk # Google Cloud CLI (gcloud)
)

echo "Installing common Homebrew casks..."

for cask in "${CASKS_TO_INSTALL[@]}"; do
    if brew list --cask | grep -q "^${cask}\$"; then
        echo "  '$cask' is already installed. Skipping."
    else
        echo "  Installing '$cask'..."
        brew install --cask "$cask"
        if [ $? -ne 0 ]; then
            echo "  Warning: Failed to install '$cask'. Continuing with other casks."
        fi
    fi
done

echo "Common Homebrew casks installation complete."
echo "--------------------------------------------------------"

echo "Installing Tmux Plugin Manager (tpm)..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    if [ $? -eq 0 ]; then
        echo "tpm installed successfully to $TPM_DIR"
    else
        echo "Warning: Failed to install tpm. Please check your internet connection and Git installation."
    fi
else
    echo "tpm is already installed at $TPM_DIR. Skipping clone."
fi

echo "Installation script finished."
echo "Remember to open a new terminal session or source your ~/.zshrc to apply PATH changes."
