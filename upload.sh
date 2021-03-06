#!/bin/bash

echo "Source env file for all variables"
source ./env

echo "Replacing styles from website header and title"
cd $DIR/themes/coder/assets/scss && sed -i 's/uppercase/none/' _navigation.scss && cd $DIR
cd $DIR/themes/coder/layouts/_default && sed -i 's/·/-/' single.html && cd $DIR

echo "Deleting old publication"
rm -rf public
mkdir public

echo "Generating site"
hugo

echo "Restore changes in theme"
cd $DIR/themes/coder && git restore . && cd $DIR

echo "<< Syncing from Local $DIR --> Remote $REMOTEFOLDER >>
-----------------------------"
lftp -e "
    set sftp:auto-confirm yes
    set ssl:verify-certificate no
    open $FTPHOST
    user $USR $PASS
    lcd $LOCALFOLDER
    mirror --reverse --verbose --transfer-all --only-newer $DIR/public/ $REMOTEFOLDER/
    bye
    "
echo "Sync Complete."
