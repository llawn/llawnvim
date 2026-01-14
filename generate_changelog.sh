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
    local commits=$(git log --oneline --pretty=format:"%s" $range)
    local added=""
    local changed=""
    local deprecated=""
    local removed=""
    local fixed=""
    local security=""
    local docs=""
    local style=""
    local refactor=""
    local test=""
    local chore=""
    local feat=""
    local other=""

    while IFS= read -r commit; do
        case "$commit" in
            feat:*)
                feat="$feat\n- ${commit#feat: }"
                ;;
            fix:*)
                fixed="$fixed\n- ${commit#fix: }"
                ;;
            docs:*)
                docs="$docs\n- ${commit#docs: }"
                ;;
            style:*)
                style="$style\n- ${commit#style: }"
                ;;
            refactor:*)
                refactor="$refactor\n- ${commit#refactor: }"
                ;;
            test:*)
                test="$test\n- ${commit#test: }"
                ;;
            chore:*)
                chore="$chore\n- ${commit#chore: }"
                ;;
            *)
                other="$other\n- $commit"
                ;;
        esac
    done <<< "$commits"

    local entry="## [$version] - $date\n\n"
    [ -n "$feat" ] && entry="$entry### Added\n$feat\n\n"
    [ -n "$changed" ] && entry="$entry### Changed\n$changed\n\n"
    [ -n "$deprecated" ] && entry="$entry### Deprecated\n$deprecated\n\n"
    [ -n "$removed" ] && entry="$entry### Removed\n$removed\n\n"
    [ -n "$fixed" ] && entry="$entry### Fixed\n$fixed\n\n"
    [ -n "$security" ] && entry="$entry### Security\n$security\n\n"
    [ -n "$docs" ] && entry="$entry### Documentation\n$docs\n\n"
    [ -n "$style" ] && entry="$entry### Style\n$style\n\n"
    [ -n "$refactor" ] && entry="$entry### Refactored\n$refactor\n\n"
    [ -n "$test" ] && entry="$entry### Tests\n$test\n\n"
    [ -n "$chore" ] && entry="$entry### Chore\n$chore\n\n"
    [ -n "$other" ] && entry="$entry$other\n\n"

    echo "$entry"
}

for TAG in $TAGS; do
    if git rev-parse --verify --quiet ${PREV_COMMIT}..${TAG} >/dev/null; then
        DATE=$(git log -1 --format=%ai ${TAG} | cut -d' ' -f1)
        ENTRY=$(generate_entry "${PREV_COMMIT}..${TAG}" "$TAG" "$DATE")
        CHANGELOG_BODY="$ENTRY$CHANGELOG_BODY"

        # Detailed for docs
        DETAILED_COMMITS=$(git log --stat --pretty=format:"commit %h %s%nAuthor: %an <%ae>%nDate: %ad%n%n%b" ${PREV_COMMIT}..${TAG} | sed 's/^/    /')
        DOCS_ENTRY="## [$TAG] - $DATE\n\n### Details of Changes\n\n\`\`\`\n$DETAILED_COMMITS\n\`\`\`\n\n"
        DOCS_BODY="$DOCS_ENTRY$DOCS_BODY"
    fi
    PREV_COMMIT=${TAG}
done

# Commits after the last tag
if git rev-parse --verify --quiet ${PREV_COMMIT}..HEAD >/dev/null; then
    DATE=$(date +%Y-%m-%d)
    NEXT_TAG=$(echo "$TAGS" | head -1 | awk -F. '{print $1"."$2"."($3+1)}')
    ENTRY=$(generate_entry "${PREV_COMMIT}..HEAD" "$NEXT_TAG" "$DATE")
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