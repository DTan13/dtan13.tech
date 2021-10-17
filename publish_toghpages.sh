#!/bin/sh

DIR=$(pwd)

if [[ $(git status -s) ]]; then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1
fi

cd $DIR/themes/coder/assets/scss && sed -i 's/uppercase/none/' _navigation.scss && cd $DIR

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

cd $DIR/themes/coder && git restore . && cd $DIR/public

echo "Updating gh-pages branch"
git add --all && git commit -m "Publishing to DTan13.github.io"
