#!/bin/bash

# Script to generate full CHANGELOG.md and docs/changelog.md from git history

# Header for CHANGELOG.md
CHANGELOG_HEADER="# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)."

# Header for docs/changelog.md
DOCS_HEADER="# Changelog"

# Get all tags sorted by version
TAGS=$(git tag --sort=-version:refname | tac)

# Start with the first commit
PREV_COMMIT=$(git rev-list --max-parents=0 HEAD)

CHANGELOG_BODY=""
DOCS_BODY=""

for TAG in $TAGS; do
    # Get commits from prev to this tag
    COMMITS=$(git log --oneline --pretty=format:"- %s" ${PREV_COMMIT}..${TAG})
    if [ -n "$COMMITS" ]; then
        DATE=$(git log -1 --format=%ai ${TAG} | cut -d' ' -f1)
        ENTRY="## [$TAG] - $DATE\n\n$COMMITS\n\n"
        CHANGELOG_BODY="$ENTRY$CHANGELOG_BODY"

        # Detailed for docs
        DETAILED_COMMITS=$(git log --stat --pretty=format:"commit %h %s%nAuthor: %an <%ae>%nDate: %ad%n%n%b" ${PREV_COMMIT}..${TAG} | sed 's/^/    /')
        DOCS_ENTRY="## [$TAG] - $DATE\n\n### Details of Changes\n\n\`\`\`\n$DETAILED_COMMITS\n\`\`\`\n\n"
        DOCS_BODY="$DOCS_ENTRY$DOCS_BODY"
    fi
    PREV_COMMIT=${TAG}
done

# Commits after the last tag
LATEST_COMMITS=$(git log --oneline --pretty=format:"- %s" ${PREV_COMMIT}..HEAD)
if [ -n "$LATEST_COMMITS" ]; then
    DATE=$(date +%Y-%m-%d)
    NEXT_TAG=$(echo $TAGS | head -1 | awk -F. '{print $1"."$2"."($3+1)}')
    ENTRY="## [$NEXT_TAG] - $DATE\n\n$LATEST_COMMITS\n\n"
    CHANGELOG_BODY="$ENTRY$CHANGELOG_BODY"

    DETAILED_COMMITS=$(git log --stat --pretty=format:"commit %h %s%nAuthor: %an <%ae>%nDate: %ad%n%n%b" ${PREV_COMMIT}..HEAD | sed 's/^/    /')
    DOCS_ENTRY="## [$NEXT_TAG] - $DATE\n\n### Details of Changes\n\n\`\`\`\n$DETAILED_COMMITS\n\`\`\`\n\n"
    DOCS_BODY="$DOCS_ENTRY$DOCS_BODY"
fi

# Write CHANGELOG.md
echo "$CHANGELOG_HEADER

$CHANGELOG_BODY" > CHANGELOG.md

# Write docs/changelog.md
echo "$DOCS_HEADER

$DOCS_BODY" > docs/changelog.md

echo "Generated full changelogs"