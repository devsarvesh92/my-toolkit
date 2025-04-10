#!/usr/bin/env bash
set -e

# Use first argument as Python version or prompt for input if not provided
if [ -n "$1" ]; then
    PYTHON_VERSION="$1"
else
    read -p "Enter Python version to install (e.g., 3.11.7): " PYTHON_VERSION
    
    # If still empty, use a fallback
    if [ -z "$PYTHON_VERSION" ]; then
        PYTHON_VERSION="3.11.7"
        echo "No version provided, using default: $PYTHON_VERSION"
    fi
fi

echo "Setting up Python development environment with Python $PYTHON_VERSION"
echo "========================================"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

# Install ASDF via Homebrew if not already installed
if ! command -v asdf &> /dev/null; then
    echo "Installing ASDF using Homebrew..."
    brew install asdf
    
    # Add ASDF to shell config (works for bash and zsh)
    SHELL_CONFIG_FILE="$HOME/.$(basename $SHELL)rc"
    if [ ! -f "$SHELL_CONFIG_FILE" ]; then
        if [[ "$SHELL" == *"zsh"* ]]; then
            SHELL_CONFIG_FILE="$HOME/.zshrc"
        else
            SHELL_CONFIG_FILE="$HOME/.bashrc"
        fi
    fi
    
    # Add ASDF to shell config if not already there
    if ! grep -q "asdf.sh" "$SHELL_CONFIG_FILE"; then
        echo "" >> "$SHELL_CONFIG_FILE"
        echo "# ASDF Version Manager (installed via Homebrew)" >> "$SHELL_CONFIG_FILE"
        echo ". \"\$(brew --prefix asdf)/libexec/asdf.sh\"" >> "$SHELL_CONFIG_FILE"
    fi
    
    # Source the ASDF script to make it available in the current session
    . "$(brew --prefix asdf)/libexec/asdf.sh"
else
    echo "ASDF is already installed, checking if it's the Homebrew version..."
    ASDF_PATH=$(which asdf)
    if [[ "$ASDF_PATH" != *"/opt/homebrew/"* && "$ASDF_PATH" != *"/usr/local/Homebrew/"* ]]; then
        echo "Warning: ASDF is installed but not through Homebrew."
        echo "Current ASDF path: $ASDF_PATH"
        echo "Consider uninstalling the current version and reinstalling via Homebrew:"
        echo "  brew install asdf"
    else
        echo "Confirmed ASDF is installed via Homebrew"
    fi
fi

# Add Python plugin to ASDF if not already added
if ! asdf plugin list | grep -q "python"; then
    echo "Adding Python plugin to ASDF..."
    asdf plugin add python
else
    echo "Python plugin is already added to ASDF"
fi

# Install the specified Python version if not already installed
if ! asdf list python | grep -q "$PYTHON_VERSION"; then
    echo "Installing Python $PYTHON_VERSION..."
    asdf install python "$PYTHON_VERSION"
else
    echo "Python $PYTHON_VERSION is already installed"
fi

# Set the Python version globally
echo "Setting Python $PYTHON_VERSION as the global version..."
asdf set python "$PYTHON_VERSION"

# Reshim Python
echo "Reshimming Python..."
asdf reshim python

# Add alias to .zshrc or .bashrc
SHELL_CONFIG_FILE="$HOME/.$(basename $SHELL)rc"
if [ ! -f "$SHELL_CONFIG_FILE" ]; then
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_CONFIG_FILE="$HOME/.zshrc"
    else
        SHELL_CONFIG_FILE="$HOME/.bashrc"
    fi
fi

# Check if there's already a python alias and remove it
if grep -q "alias python=" "$SHELL_CONFIG_FILE"; then
    sed -i '' '/alias python=/d' "$SHELL_CONFIG_FILE"
fi

# Add the new alias
echo "Adding Python alias to shell config..."
echo "alias python=\"$HOME/.asdf/shims/python\"" >> "$SHELL_CONFIG_FILE"
echo "alias python3=\"$HOME/.asdf/shims/python3\"" >> "$SHELL_CONFIG_FILE"

# Install PDM using Homebrew if not already installed
if ! command -v pdm &> /dev/null; then
    echo "Installing PDM using Homebrew..."
    brew install pdm
else
    echo "PDM is already installed"
    PDM_PATH=$(which pdm)
    if [[ "$PDM_PATH" != *"/opt/homebrew/"* && "$PDM_PATH" != *"/usr/local/Homebrew/"* ]]; then
        echo "Note: PDM is installed but not through Homebrew."
        echo "Current PDM path: $PDM_PATH"
    fi
fi

# Configure PDM to use UV by setting the use-uv option to true
echo "Configuring PDM to use UV..."
mkdir -p ~/.config/pdm
if [ ! -f ~/.config/pdm/config.toml ]; then
    echo "[tool.pdm]" > ~/.config/pdm/config.toml
    echo "use-uv = true" >> ~/.config/pdm/config.toml
else
    # Check if config already has use-uv setting
    if grep -q "use-uv" ~/.config/pdm/config.toml; then
        # Update existing setting
        sed -i '' 's/use-uv = .*/use-uv = true/' ~/.config/pdm/config.toml
    else
        # Add setting
        if grep -q "\[tool.pdm\]" ~/.config/pdm/config.toml; then
            # Add under existing section
            sed -i '' '/\[tool.pdm\]/a\'$'\n''use-uv = true' ~/.config/pdm/config.toml
        else
            # Add new section
            echo "[tool.pdm]" >> ~/.config/pdm/config.toml
            echo "use-uv = true" >> ~/.config/pdm/config.toml
        fi
    fi
fi

# Install UV package installer using Homebrew
if ! command -v uv &> /dev/null; then
    echo "Installing UV package installer using Homebrew..."
    brew install uv
else
    echo "UV package installer is already installed"
    UV_PATH=$(which uv)
    if [[ "$UV_PATH" != *"/opt/homebrew/"* && "$UV_PATH" != *"/usr/local/Homebrew/"* ]]; then
        echo "Note: UV is installed but not through Homebrew."
        echo "Current UV path: $UV_PATH"
    fi
fi

# Check if there's already a python alias and remove it
if grep -q "alias python=" "$SHELL_CONFIG_FILE"; then
    sed -i '' '/alias python=/d' "$SHELL_CONFIG_FILE"
fi

# Check if there's already a python3 alias and remove it
if grep -q "alias python3=" "$SHELL_CONFIG_FILE"; then
    sed -i '' '/alias python3=/d' "$SHELL_CONFIG_FILE"
fi

# Add the new alias
echo "Adding Python alias to shell config..."
echo "alias python=\"$HOME/.asdf/shims/python\"" >> "$SHELL_CONFIG_FILE"
echo "alias python3=\"$HOME/.asdf/shims/python3\"" >> "$SHELL_CONFIG_FILE"

echo "========================================"
echo "Setup complete!"
echo ""
echo "Python $PYTHON_VERSION has been installed and configured."
echo "PDM has been installed and configured to use UV."
echo ""
echo "Please restart your terminal or run 'source $SHELL_CONFIG_FILE' to apply the changes."
echo "You can then use 'python --version' to verify the installation."
echo "Execute pdm venv create to create a virtual environment."
echo "To activate the virtual environment, run:"
echo "eval $(pdm venv activate in-project)"