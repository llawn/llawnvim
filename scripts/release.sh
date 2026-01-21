#!/bin/bash

# Pre-push hook to update changelogs if pushing tags

while read -r local_ref; do
  if [[ "$local_ref" == refs/tags/* ]]; then
    tag_name=${local_ref#refs/tags/}
    echo "Pushing tag $local_ref, updating changelogs..."
    if make changelog; then
      # Replace [Unreleased] with the tag name if it exists
      sed -i "s/^## \[Unreleased\]/## [$tag_name]/" CHANGELOG.md docs/changelog.md
      # Remove duplicate tag headers, keeping the first
      for file in CHANGELOG.md docs/changelog.md; do
        awk '!seen[$0]++ || !/^## \['"${tag_name}"'\]/{print}' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
      done
      git add CHANGELOG.md docs/changelog.md
      git commit -S -m "docs: update changelogs"
      echo "Changelogs updated and committed."
    fi
    break
  fi
done
