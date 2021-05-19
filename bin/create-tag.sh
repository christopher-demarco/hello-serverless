#!/bin/bash

set -e

# Create a tag using the contents of the VERSION file in the toplevel
# of the repo.

# Prompt the user for the tag description.

VERSION=$(cat VERSION)

read -e -p 'Tag description: ' DESC

echo Pushing $VERSION as $DESC

git tag -a $VERSION -m "$DESC"
git push --tags
