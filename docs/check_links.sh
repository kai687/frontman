#!/bin/sh

# Check ALL links with lychee
# To install lychee with Homebrew, run `brew install lychee`

build_dir="build"

if ! test -d "$build_dir"; then
    echo "Directory '${build_dir}' not found. Running a build first."
    bundle exec frontman build
fi

if ! command -v lychee >/dev/null 2>&1; then
    echo "Link checker not installed."
    echo "Install Lychee (https://github.com/lycheeverse/lychee) and run this script again"
    exit 1
fi

lychee "$build_dir" --exclude-all-private --base "$build_dir" --exclude "gstatic.com" --exclude "googleapis.com"  "${@}"
