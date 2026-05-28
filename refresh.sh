#!/usr/bin/env bash

set -e

SUBMODULE="workspace"
REPO="https://github.com/code-hemu/extensions-workspace.git"

# =========================
# Options
# =========================

read -p "Workspace submodule reset? (y/n): " RESET_SUBMODULE

read -p "Create new extension project folder structure? (y/n): " CREATE_STRUCTURE

# =========================
# Reset submodule
# =========================

if [[ "$RESET_SUBMODULE" =~ ^[Yy]$ ]]; then

    echo ""
    echo "Resetting submodule: $SUBMODULE"

    # Remove old submodule if available
    git submodule deinit -f "$SUBMODULE" 2>/dev/null || true
    git rm -f "$SUBMODULE" 2>/dev/null || true

    rm -rf ".git/modules/$SUBMODULE"
    rm -rf "$SUBMODULE"

    # Commit removal
    git add . || true

    if ! git diff --cached --quiet; then
        git commit -m "Remove $SUBMODULE submodule" || true
        git push || true
    fi

    echo ""
    echo "Adding workspace submodule..."

    # Add submodule again
    git submodule add -b main "$REPO" "$SUBMODULE"

fi

# =========================
# Create folder structure using Node.js
# =========================

if [[ "$CREATE_STRUCTURE" =~ ^[Yy]$ ]]; then

    echo ""
    echo "Creating extension project structure using Node.js..."

    node -e "
        const fs = require('fs');

        fs.mkdirSync('src', { recursive: true });
        fs.mkdirSync('config', { recursive: true });

        fs.writeFileSync('src/app.js', '');
        fs.writeFileSync('src/index.html', '');
        fs.writeFileSync('src/style.scss', '');

        fs.writeFileSync('config/chrome.js', '');
        fs.writeFileSync('config/edge.js', '');

        console.log('Created files successfully');
    "

    echo ""
    echo "Created files:"
    echo "src/app.js"
    echo "src/index.html"
    echo "src/style.scss"
    echo "config/chrome.js"
    echo "config/edge.js"

fi

# =========================
# Final commit
# =========================

git add .

if ! git diff --cached --quiet; then
    git commit -m "Update workspace and project structure" || true
    git push || true
fi

echo ""
echo "Completed successfully"