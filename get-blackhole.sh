#!/bin/sh

TEMPFILE=`tempfile`
TARGET="/etc/bind/blackhole-yoyo.conf"

wget -O $TEMPFILE \
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=bindconfig&showintro=0&mimetype=plaintext&zonefilename=/etc/bind/db.blackhole" || exit 1

diff -q $TARGET $TEMPFILE && echo "No change, exiting..." && exit 0
diff -Naur $TARGET $TEMPFILE | less

echo "Installing new file..."
mv $TEMPFILE $TARGET
chgrp bind $TARGET
chmod g+r $TARGET
rndc reload
