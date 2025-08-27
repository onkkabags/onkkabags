#!/bin/bash
################################################################################
# Script: generate-images.sh
# Description: 
#   Processes only original JPEG images in the current folder (both .jpg and .jpeg)
#   that do NOT already have a width suffix (e.g., -320, -500).
#   Generates resized versions in JPEG, WebP, and AVIF formats.
#
# Target widths: 320, 500, 800, 1000 pixels.
# Output: Files named <original>-<width>.<format> in the same folder.
#
# How to run:
#   1. Open terminal and navigate to this folder (img/):
#        cd /Users/alonkka/Documents/GitHub/onkkabags/img
#   2. Make the script executable (first time only):
#        chmod +x generate-images.sh
#   3. Run the script:
#        ./generate-images.sh
################################################################################

# Target widths
widths=(320 500 800 1000)

# Loop through original JPEGs only (exclude files already with -<width> in name)
for file in *.jpg *.jpeg; do
  # Skip if no matches
  [ -e "$file" ] || continue

  # Skip already resized files (contain -<number>)
  if [[ "$file" =~ -[0-9]+\.jpe?g$ ]]; then
    continue
  fi

  # Strip extension for output filenames
  filename=$(basename "$file" .jpg)
  filename=${filename%.jpeg}

  # Loop through target widths
  for w in "${widths[@]}"; do
    # Resized JPEG
    magick "$file" -resize "${w}" "${filename}-${w}.jpg"
    # Resized WebP
    magick "$file" -resize "${w}" "${filename}-${w}.webp"
    # Resized AVIF
    magick "$file" -resize "${w}" "${filename}-${w}.avif"
  done

  echo "Processed $file"
done

echo "All new original images resized to AVIF, WebP, and JPEG in this folder."