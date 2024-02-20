#!/bin/bash

# Run the Vale style linter
# To install Vale with Homebrew, run `brew install vale`
# The configuration is in `.vale.ini`

content_dir="content"

if command -v vale >/dev/null 2>&1; then
  vale "${content_dir}" "${@}"
else
  echo "Vale not installed."
  echo "Install Vale (https://vale.sh/docs/vale-cli/installation) and run this script again."
fi
