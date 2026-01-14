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

generate_entry() {
    local range="$1"
    local version="$2"
    local date="$3"
    local commits=$(git log --pretty=format:"- %s" $range)
    echo "## [$version] - $date\n\n$commits\n"
}

for TAG in $TAGS; do
    DATE=$(git log -1 --format=%ai ${TAG} | cut -d' ' -f1)
    ENTRY=$(generate_entry "${PREV_COMMIT}..${TAG}" "$TAG" "$DATE")
    CHANGELOG_BODY="$ENTRY$CHANGELOG_BODY"

    # Detailed for docs
    DETAILED_COMMITS=$(git log --stat --pretty=format:"commit %h %s%nAuthor: %an <%ae>%nDate: %ad%n%n%b" ${PREV_COMMIT}..${TAG} | sed 's/^/    /')
    DOCS_ENTRY="## [$TAG] - $DATE\n\n### Details of Changes\n\n\`\`\`\n$DETAILED_COMMITS\n\`\`\`\n\n"
    DOCS_BODY="$DOCS_ENTRY$DOCS_BODY"
    PREV_COMMIT=${TAG}
done

# Commits after the last tag
DATE=$(date +%Y-%m-%d)
LATEST_TAG=$(echo "$TAGS" | tail -1)
NEXT_TAG=$(echo "$LATEST_TAG" | awk -F. '{print $1"."$2"."($3+1)}')
ENTRY=$(generate_entry "${PREV_COMMIT}..HEAD" "$NEXT_TAG" "$DATE")
CHANGELOG_BODY="$ENTRY$CHANGELOG_BODY"

DETAILED_COMMITS=$(git log --stat --pretty=format:"commit %h %s%nAuthor: %an <%ae>%nDate: %ad%n%n%b" ${PREV_COMMIT}..HEAD | sed 's/^/    /')
DOCS_ENTRY="## [$NEXT_TAG] - $DATE\n\n### Details of Changes\n\n\`\`\`\n$DETAILED_COMMITS\n\`\`\`\n\n"
DOCS_BODY="$DOCS_ENTRY$DOCS_BODY"

# Write CHANGELOG.md
echo "$CHANGELOG_HEADER

$CHANGELOG_BODY" > CHANGELOG.md

# Write docs/changelog.md
echo "$DOCS_HEADER

$DOCS_BODY" > docs/changelog.md

echo "Generated full changelogs"