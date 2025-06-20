#!/bin/bash
# Script to set up a test repository for Claude Action Auth

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Claude Action Auth Test Setup${NC}"
echo "======================="
echo ""

# Check if test repo name provided
REPO_NAME="${1:-test-claude-action-auth-demo}"
TEST_DIR="../$REPO_NAME"

# Create test repository
echo "1. Creating test repository: $REPO_NAME"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Initialize git
echo "2. Initializing git repository..."
git init

# Add test files if they don't exist
if [ ! -f "README.md" ]; then
    cat > README.md << 'EOF'
# Test Claude Action Auth Demo

This is a test repository to verify Claude Code Action authentication integration.

## Purpose
- Test authentication setup with claude-auth tool
- Verify GitHub Action triggers on @claude mentions
- Test auto-PR creation from issues

## Test Plan
1. Install claude-auth tool
2. Run authentication setup
3. Create test issue
4. Add @claude comment
5. Verify Claude Code responds
EOF
fi

if [ ! -f "main.js" ]; then
    cat > main.js << 'EOF'
// Simple test file for Claude Code to work with

function greet(name) {
    console.log(`Hello, ${name}!`);
}

function add(a, b) {
    // TODO: This needs error handling
    return a + b;
}

// Test the functions
greet("World");
console.log("2 + 3 =", add(2, 3));
EOF
fi

if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
.DS_Store
*.log
node_modules/
.env
EOF
fi

# Initial commit
echo "3. Creating initial commit..."
git add .
git commit -m "Initial commit: test repository for Claude Action Auth"

# Create GitHub repository
echo ""
echo -e "${YELLOW}4. Creating GitHub repository...${NC}"
gh repo create "$REPO_NAME" --private --source=. --remote=origin --push

# Install claude-auth
echo ""
echo "5. Installing claude-auth tool..."
if command -v claude-auth &> /dev/null; then
    echo -e "${GREEN}✓ claude-auth already installed${NC}"
else
    echo "Installing from remote..."
    curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-action-auth/main/install.sh | bash
fi

# Run authentication setup
echo ""
echo "6. Running authentication setup..."
echo -e "${YELLOW}Select option 1 (OAuth) when prompted${NC}"
claude-auth setup

# Instructions for testing
echo ""
echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo ""
echo "Next steps to test:"
echo "1. Go to: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/issues"
echo "2. Create a new issue with title: 'Test Claude Code'"
echo "3. In the issue body, write:"
echo "   @claude Please add error handling to the add function in main.js"
echo "4. Submit the issue and watch Claude Code respond!"
echo ""
echo "To view the Action run:"
echo "https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions"
echo ""
echo -e "${BLUE}Repository location: $(pwd)${NC}"