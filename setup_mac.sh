echo "Setting local machine up for development"
echo "========================================"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
    echo "You can now use Homebrew to install packages."
    brew upgrade
    echo "Homebrew has been upgraded successfully."
fi

# Check if Rectangle is installed
if ! command -v rectangle &> /dev/null; then
    echo "Installing Rectangle..."
    brew install --cask rectangle
else
    echo "Rectangle is already installed"
fi

# Check if Flycut is installed
if ! command -v flycut &> /dev/null; then
    echo "Installing Flycut..."
    brew install --cask flycut
else
    echo "Flycut is already installed"
fi

# Check if iTerm2 is installed
if ! command -v iterm2 &> /dev/null; then
    echo "Installing iTerm2..."
    brew install --cask iterm2
else
    echo "iTerm2 is already installed"
fi

# Check if Visual Studio Code is installed

if ! command -v code &> /dev/null; then
    echo "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
else
    echo "Visual Studio Code is already installed"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    brew install --cask docker
else
    echo "Docker is already installed"
fi

# Check if Postman is installed
if ! command -v postman &> /dev/null; then
    echo "Installing Postman..."
    brew install --cask postman
else
    echo "Postman is already installed"
fi

# Check if Slack is installed
if ! command -v slack &> /dev/null; then
    echo "Installing Slack..."
    brew install --cask slack
else
    echo "Slack is already installed"
fi

# Check if tree is installed
if ! command -v tree &> /dev/null; then
    echo "Installing tree..."
    brew install tree
else
    echo "Tree is already installed"
fi

# Check if alfred is installed
if ! command -v alfred &> /dev/null; then
    echo "Installing Alfred..."
    brew install --cask alfred
else
    echo "Alfred is already installed"
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    brew install awscli
else
    echo "AWS CLI is already installed"
fi

# Check if chatgpt is installed
if ! command -v chatgpt &> /dev/null; then
    echo "Installing ChatGPT..."
    brew install --cask chatgpt
else
    echo "ChatGPT is already installed"
fi

# Check if dbeaver is installed
if ! command -v dbeaver &> /dev/null; then
    echo "Installing DBeaver..."
    brew install --cask dbeaver-community
else
    echo "DBeaver is already installed"
fi

# Check if claude is installed
if ! command -v claude &> /dev/null; then
    echo "Installing Claude..."
    brew install --cask claude
else
    echo "Claude is already installed"
fi

