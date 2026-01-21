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

# 2. Finalize the Unreleased file into a Version file
# We move the unreleased.md to its permanent version name if it exists
if [ -f "docs/changelog/unreleased.md" ]; then
    mv "docs/changelog/unreleased.md" "docs/changelog/${TAG_NAME}.md"
    # Update the title inside the new file from "Unreleased" to the Tag Name
    sed -i "s/# Unreleased/# Release $TAG_NAME/" "docs/changelog/${TAG_NAME}.md"
fi

# 3. Commit the version file
git add docs/changelog/${TAG_NAME}.md
git commit -S -m "chore(release): $TAG_NAME"

# 4. Create the signed tag on the commit
git tag -s "$TAG_NAME" -m "Release $TAG_NAME"

# 5. Generate the changelog again now that the tag exists
echo "Generating final changelog..."
make changelog

# 6. Amend the commit with the updated CHANGELOG.md and index.md
git add CHANGELOG.md docs/changelog/index.md
git commit --amend --no-edit

# 7. Update the tag to point to the amended commit
git tag -d "$TAG_NAME"
git tag -s "$TAG_NAME" -m "Release $TAG_NAME"

# 8. Push
git push origin main
git push origin "$TAG_NAME"

echo "✅ Release $TAG_NAME complete!"
