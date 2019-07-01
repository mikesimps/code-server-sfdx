#!/bin/bash

EXTLIST="/tmp/extensions.list"

echo "fetching additional extentions list..."
[ ! -z $1 ] && curl --silent $1 >> $EXTLIST

while IFS="" read -r p || [ -n "$p" ]
do
  P="$(cut -d'.' -f1 <<<"$p")"
  E="$(cut -d'.' -f2 <<<"$p")"
  DIR="$CS_EXTDIR/$p"
  if [ ! -d $DIR ] || [ ! "$(ls -A $DIR)" ]; then
    echo "fetching $p to $CS_EXTDIR/extension"
    curl -JL "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$P/vsextensions/$E/latest/vspackage" | bsdtar -xv -C $CS_EXTDIR -f - extension 2>/dev/null
    sleep 3 #need to sleep or marketplace throttles downloads
    mv $CS_EXTDIR/extension $DIR
  else
    echo "skipping $p"
  fi
done <$EXTLIST