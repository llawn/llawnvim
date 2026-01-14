#!/bin/bash

# Script to update CHANGELOG.md automatically before pushing tags

# Get the latest tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")

# Get commits since latest tag
COMMITS=$(git log --oneline --pretty=format:"- %s" ${LATEST_TAG}..HEAD)

if [ -n "$COMMITS" ]; then
    # Generate new entry
    DATE=$(date +%Y-%m-%d)
    NEW_VERSION=$(echo $LATEST_TAG | awk -F. '{print $1"."$2"."($3+1)}')
    ENTRY="## [$NEW_VERSION] - $DATE\n\n$COMMITS\n"

    # Prepend to CHANGELOG.md
    sed -i "1a $ENTRY" CHANGELOG.md
    echo "Updated CHANGELOG.md with new version $NEW_VERSION"
else
    echo "No new commits since $LATEST_TAG"
fi