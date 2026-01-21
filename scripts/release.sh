#!/bin/bash
set -e

TAG_NAME=$1

# Check if tag name was provided
if [ -z "$TAG_NAME" ]; then
    echo "Usage: ./scripts/release.sh <tag-name>"
    exit 1
fi

echo "🚀 Starting release process for $TAG_NAME..."

# 1. Update the changelog
# If you don't have a Makefile, you can remove the 'if make changelog' block
if make changelog; then
    # Note: If on macOS and this fails, use: sed -i '' "s/..."
    sed -i "s/^## \[Unreleased\]/## [$TAG_NAME]/" CHANGELOG.md docs/changelog.md
fi

# 2. Commit the changes
git add CHANGELOG.md docs/changelog.md
git commit -S -m "docs: update changelogs for $TAG_NAME"

# 3. Create the signed tag
git tag -s "$TAG_NAME" -m "Release $TAG_NAME"

# 4. Push
git push origin main
git push origin "$TAG_NAME"

echo "✅ Done!"
