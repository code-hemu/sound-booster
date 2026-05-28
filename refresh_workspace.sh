#!/usr/bin/env bash

set -e

SUBMODULE="workspace"
REPO="https://github.com/code-hemu/extensions-workspace.git"

read -p "Create project folder structure? (y/n): " CREATE_STRUCTURE

echo "Resetting submodule: $SUBMODULE"

# Remove existing submodule
git submodule deinit -f "$SUBMODULE" || true
git rm -f "$SUBMODULE" || true
rm -rf ".git/modules/$SUBMODULE"

# Commit removal if needed
if ! git diff --quiet; then
  git commit -m "Remove $SUBMODULE submodule"
  git push
fi

echo "Adding submodule again..."

git submodule add -b main "$REPO" "$SUBMODULE"

# Create folder structure
if [[ "$CREATE_STRUCTURE" =~ ^[Yy]$ ]]; then
  echo "Creating folder structure..."

  mkdir -p src config

  touch src/app.js
  touch src/index.html
  touch src/style.scss

  touch config/chrome.js
  touch config/edge.js

  echo "Folder structure created:"
  echo "src/app.js"
  echo "src/index.html"
  echo "src/style.scss"
  echo "config/chrome.js"
  echo "config/edge.js"
fi

git add .
git commit -m "Add $SUBMODULE submodule and project structure"
git push

echo "Submodule reset completed"