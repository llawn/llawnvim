#!/bin/bash
set -e

TAG_NAME=$1

if [ -z "$TAG_NAME" ]; then
    echo "Usage: ./scripts/release.sh <tag-name>"
    exit 1
fi

echo "🚀 Starting release process for $TAG_NAME..."

# 1. Run the generator script we built
# This ensures all current HEAD changes are captured in docs/changelog/unreleased.md
echo "Generating latest logs..."
make changelog

# 2. Finalize the Unreleased file into a Version file
# We move the auto-generated unreleased.md to its permanent version name
if [ -f "docs/changelog/unreleased.md" ]; then
    mv "docs/changelog/unreleased.md" "docs/changelog/${TAG_NAME}.md"
    # Update the title inside the new file from "Unreleased" to the Tag Name
    sed -i "s/# Unreleased/# Release $TAG_NAME/" "docs/changelog/${TAG_NAME}.md"
fi

# 4. Commit the changes
git add CHANGELOG.md docs/changelog/
git commit -S -m "chore(release): $TAG_NAME"

# 5. Create the signed tag
git tag -s "$TAG_NAME" -m "Release $TAG_NAME"

# 6. Push
git push origin main
git push origin "$TAG_NAME"

echo "✅ Release $TAG_NAME complete!"
