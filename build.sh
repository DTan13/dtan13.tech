#!/bin/sh

DIR=$(pwd)

echo "Deleting old publication"
rm -rf public
mkdir public

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
