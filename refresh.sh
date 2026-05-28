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
# Remove existing folders/files first
# =========================

if [[ "$CREATE_STRUCTURE" =~ ^[Yy]$ ]]; then

    echo ""
    echo "Recreating extension project structure using Node.js..."

    node -e "
        const fs = require('fs');

        // Remove existing folders/files
        fs.rmSync('src', { recursive: true, force: true });
        fs.rmSync('config', { recursive: true, force: true });

        // Create folders
        fs.mkdirSync('src/js', { recursive: true });
        fs.mkdirSync('src/html', { recursive: true });
        fs.mkdirSync('src/css', { recursive: true });
        fs.mkdirSync('src/manifest', { recursive: true });
        fs.mkdirSync('src/assets', { recursive: true });

        fs.mkdirSync('config', { recursive: true });

        // Create files
        fs.writeFileSync('src/js/index.js', '');
        fs.writeFileSync('src/html/index.html', '');
        fs.writeFileSync('src/css/style.css', '');
        fs.writeFileSync('src/manifest/manifest.json', '');

        fs.writeFileSync('config/chrome.js', '');
        fs.writeFileSync('config/edge.js', '');
        fs.writeFileSync('config/naver.js', '');
        fs.writeFileSync('config/opera.js', '');

        console.log('Project structure recreated successfully');
    "

    echo ""
    echo "Created structure:"
    echo "src/js/index.js"
    echo "src/html/index.html"
    echo "src/css/style.css"
    echo "src/manifest/manifest.json"
    echo "src/assets/"
    echo "config/chrome.js"
    echo "config/edge.js"
    echo "config/naver.js"
    echo "config/opera.js"

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