# GitHub Configuration

This directory contains GitHub repository configuration files for better issue and project management.

## Issue Templates

Located in `.github/ISSUE_TEMPLATE/`, these YAML files provide structured forms for different types of issues:

- **bug-report.yml**: For reporting bugs with detailed reproduction steps
- **feature-request.yml**: For suggesting new features or enhancements
- **documentation.yml**: For documentation issues and improvements
- **question.yml**: For questions and support requests

These templates help contributors provide the necessary information for efficient issue resolution.

## Applying Labels

To apply the recommended labels to your repository, run:

```bash
./scripts/apply-github-labels.sh
```

This script uses GitHub CLI to create all the labels with appropriate colors and descriptions.

## Customization

You can modify the templates and labels to fit your project's specific needs:

- Edit the YAML files in `ISSUE_TEMPLATE/` to change form fields
- Update the `apply-github-labels.sh` script if you change the label definitions
