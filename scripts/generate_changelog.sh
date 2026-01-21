#!/bin/bash
# @description: Generates a root CHANGELOG.md and a split docs/changelog/ directory.
# @usage: Run from project root.

CHANGELOG_DIR="docs/changelog"
mkdir -p "$CHANGELOG_DIR"

# --- Headers ---
ROOT_HEADER="# Changelog\n\nAll notable changes to this project will be documented in this file.\n\n---\n"
DOCS_INDEX_HEADER="---\ntitle: Changelog\nicon: material/history\n---\n\n# Version History\n\nBrowse detailed technical logs for each release.\n"

# --- State ---
TAGS=$(git tag --sort=-version:refname)
PREV_COMMIT=$(git rev-list --max-parents=0 HEAD)
ROOT_BODY=""
INDEX_LINKS=""

# Function to extract commits and format as a Markdown Table
generate_table() {
  local range="$1"
  # Format: | Hash | Type | Subject | Author |
  # We use sed to extract the conventional commit type (feat, fix, etc.)
  git log "$range" --pretty=format:"| \`%h\` | %s | %an |" | \
    sed -E 's/\| ([a-z]+)(\(.*\))?: /| \1 | /'
  }

# 1. Process Tags
# We need to process tags in chronological order to define ranges,
# but we'll build the strings for the index in reverse (newest first).
ALL_TAGS_ASC=$(git tag --sort=version:refname)

for TAG in $ALL_TAGS_ASC; do
  DATE=$(git log -1 --format=%ai "${TAG}" | cut -d' ' -f1)
  RANGE="${PREV_COMMIT}..${TAG}"

    # Generate content for individual file
    FILE_NAME="${TAG}.md"
    TABLE_CONTENT=$(generate_table "$RANGE")
    DIFF_STATS=$(git log --stat "${RANGE}")

    {
      echo "---"
      echo "title: Release $TAG"
      echo "---"
      echo "# Release $TAG ($DATE)"
      echo -e "\n### Commit Summary"
      echo "| Hash | Type | Description | Author |"
      echo "| :--- | :--- | :--- | :--- |"
      echo "$TABLE_CONTENT"
      echo -e "\n### Technical Stats"
      echo "<details><summary>View File Changes and Statistics</summary>"
      echo -e "\n\`\`\`text\n$DIFF_STATS\n\`\`\`\n</details>"
    } > "$CHANGELOG_DIR/$FILE_NAME"

    # Build root CHANGELOG.md entry (Simple list)
    ROOT_ENTRY="## [$TAG] - $DATE\n$(git log "$RANGE" --pretty=format:"- %s (%h)")\n\n"
    ROOT_BODY="$ROOT_ENTRY$ROOT_BODY"

    # Build Index links (Newest at top)
    INDEX_LINKS="- [$TAG]($FILE_NAME) - $DATE\n$INDEX_LINKS"

    PREV_COMMIT=${TAG}
  done

# 2. Handle Unreleased Changes
DATE_NOW=$(date +%Y-%m-%d)
UNRELEASED_RANGE="${PREV_COMMIT}..HEAD"

if [ "$(git rev-parse HEAD)" != "$(git rev-parse "$PREV_COMMIT")" ]; then
  {
    echo "# Unreleased"
    echo "| Hash | Type | Description | Author |"
    echo "| :--- | :--- | :--- | :--- |"
    generate_table "$UNRELEASED_RANGE"
  } > "$CHANGELOG_DIR/unreleased.md"
INDEX_LINKS="- [Unreleased (Draft)](unreleased.md)\n$INDEX_LINKS"
fi

# 3. Finalize Index and Root File
echo -e "$ROOT_HEADER\n$ROOT_BODY" > CHANGELOG.md
echo -e "$DOCS_INDEX_HEADER\n\n$INDEX_LINKS" > "$CHANGELOG_DIR/index.md"

echo "✅ Changelogs generated: CHANGELOG.md and $CHANGELOG_DIR/"
