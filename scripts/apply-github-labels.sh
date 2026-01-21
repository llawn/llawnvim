#!/bin/bash
# Script to apply GitHub labels to the repository
# Run this script to create all the recommended labels

# Array of label configurations
labels=(
    "bug:d73a49:Something isn't working"
    "critical:b60205:Critical bug that needs immediate attention"
    "regression:ea7079:Feature that worked before but now doesn't"
    "enhancement:a2eeef:New feature or request"
    "feature:84b6eb:New feature implementation"
    "plugin:c5def5:Related to plugin configuration or addition"
    "documentation:0075ca:Improvements or additions to documentation"
    "docs:006b75:Documentation updates needed"
    "refactor:fbca04:Code refactoring needed"
    "performance:fef2c0:Performance-related issues"
    "security:ee0701:Security-related issues"
    "maintenance:fbca04:Maintenance tasks"
    "dependencies:0366d6:Dependency updates"
    "ci/cd:000000:CI/CD pipeline issues"
    "question:d876e3:Question or support request"
    "help wanted:008672:Extra attention is needed"
    "good first issue:7057ff:Good for newcomers"
    "discussion:e99695:Open for discussion"
    "wontfix:ffffff:This will not be worked on"
    "duplicate:cfd3d7:This issue or pull request already exists"
    "invalid:e4e669:This doesn't seem right"
    "stale:237da6:Old issue that needs review"
    "linux:f7c6c7:Linux-specific"
    "macos:fef2c0:macOS-specific"
    "windows:1d76db:Windows-specific"
    "lsp:0e8a16:Language Server Protocol related"
    "lua:000080:Lua-specific"
    "python:3776ab:Python-specific"
    "typescript:3178c6:TypeScript/JavaScript specific"
    "priority: high:b60205:High priority"
    "priority: medium:fbca04:Medium priority"
    "priority: low:0e8a16:Low priority"
)

echo "Applying GitHub labels to repository..."

for label in "${labels[@]}"; do
    # Split the label string: name:color:description
    IFS=':' read -r name color description <<< "$label"

    echo "Creating label: $name"
    gh label create "$name" --description "$description" --color "$color" --force
done

echo "All labels applied successfully!"