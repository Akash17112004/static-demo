#!/usr/bin/env bash
set -e
mkdir -p css js img
grep -RHoP '(https?://talkie-wordpress\\.iqonic\\.design/wp-content/[^"]+\\.(css|js|png|jpe?g|gif|webp|ico))' docs/*.html | sort -u > external-assets.txt
while read -r url; do
  ext="${url##*.}"
  filename="$(basename "${url%%\?*}")"
  case "$ext" in
    css) dest=css ;;
    js) dest=js ;;
    *) dest=img ;;
  esac
  echo "Downloading $url → $dest/$filename"
  wget -q "$url" -O "$dest/$filename"
done < external-assets.txt
while read -r url; do
  filename="$(basename "${url%%\?*}")"
  case "$filename" in *.css) folder="css" ;; *.js) folder="js" ;; *) folder="img" ;; esac
  sed -i -E "s|$url|../$folder/$filename|g" docs/*.html
done < external-assets.txt
rm -f external-assets.txt
