#!/bin/bash
set -e

TAG_NAME=$1

if [ -z "$TAG_NAME" ]; then
    echo "Usage: ./scripts/release.sh <tag-name>"
    exit 1
fi

echo "🚀 Starting release process for $TAG_NAME..."

# 1. Generate initial changelog to capture unreleased changes
echo "Generating initial changelog..."
make changelog

# 2. Create the signed tag on the current commit
git tag -s "$TAG_NAME" -m "Release $TAG_NAME"

# 3. Generate the changelog again now that the tag exists
echo "Generating final changelog..."
make changelog

# 4. Amend the current commit with the updated CHANGELOG.md and changelog files
git add CHANGELOG.md
git add docs/changelog
git commit --amend --no-edit

# 5. Update the tag to point to the amended commit
git tag -d "$TAG_NAME"
git tag -s "$TAG_NAME" -m "Release $TAG_NAME"

# 6. Pull any remote changes
git pull --rebase

# 7. Push
git push origin main
git push origin "$TAG_NAME"

echo "✅ Release $TAG_NAME complete!"
