# GitHub Configuration

This directory contains GitHub repository configuration files for better issue and project management.

## Issue Templates

Located in `.github/ISSUE_TEMPLATE/`, these YAML files provide structured forms for different types of issues:

- **bug-report.yml**: For reporting bugs with detailed reproduction steps
- **feature-request.yml**: For suggesting new features or enhancements
- **documentation.yml**: For documentation issues and improvements
- **question.yml**: For questions and support requests

These templates help contributors provide the necessary information for efficient issue resolution.

## Labels

The `labels.yml` file contains a comprehensive set of labels for categorizing issues and pull requests. Labels are organized by:

- **Bug Reports**: bug, critical, regression
- **Feature Requests**: enhancement, feature, plugin
- **Documentation**: documentation, docs
- **Code Quality**: refactor, performance, security
- **Maintenance**: maintenance, dependencies, ci/cd
- **Support**: question, help wanted, good first issue
- **Status**: wontfix, duplicate, invalid, stale
- **Platforms**: linux, macos, windows
- **Languages**: lsp, lua, python, typescript
- **Priority**: priority levels

## Applying Labels

To apply the recommended labels to your repository, run:

```bash
./scripts/apply-github-labels.sh
```

This script uses GitHub CLI to create all the labels with appropriate colors and descriptions.

## Customization

You can modify the templates and labels to fit your project's specific needs:

- Edit the YAML files in `ISSUE_TEMPLATE/` to change form fields
- Modify `labels.yml` to add, remove, or change labels
- Update the `apply-github-labels.sh` script if you change the label definitions