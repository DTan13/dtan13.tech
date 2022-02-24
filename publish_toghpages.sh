#!/bin/sh

DIR=$(pwd)

if [[ $(git status -s) ]]; then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Restore changes in theme"
cd $DIR/themes/coder && git restore . && cd $DIR

echo "Replacing styles from website header and title"
cd $DIR/themes/coder/assets/scss && sed -i 's/uppercase/none/' _navigation.scss && cd $DIR
cd $DIR/themes/coder/layouts/_default && sed -i 's/·/-/' single.html && cd $DIR

echo "Generating site"
hugo

echo "Restore changes in theme"
cd $DIR/themes/coder && git restore . && cd $DIR

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to dtan13.tech" && cd ..
