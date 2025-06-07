#!/bin/zsh

# Create base icon with gradient background and camera design
convert -size 1024x1024 \
    gradient:blue-purple \
    -fill white \
    -draw "circle 512,512 512,912" \
    -fill '#007AFF' \
    -draw "circle 512,512 512,712" \
    -fill white \
    -draw "circle 512,512 512,612" \
    -fill '#007AFF' \
    -draw "circle 512,512 512,512" \
    -fill white \
    -font Helvetica-Bold \
    -pointsize 400 \
    -gravity center \
    -draw "text 0,0 'B'" \
    -fill white \
    -draw "path 'M 700,400 L 800,400 L 800,600 L 700,600 Z M 750,450 L 850,500 L 750,550 Z'" \
    -fill white \
    -draw "circle 700,500 700,550" \
    -fill '#007AFF' \
    -draw "circle 700,500 700,530" \
    ./Resources/BertCam/Assets.xcassets/AppIcon.appiconset/Icon-1024.png

# Add a subtle shadow effect
convert ./Resources/BertCam/Assets.xcassets/AppIcon.appiconset/Icon-1024.png \
    \( +clone -background black -shadow 80x3+0+0 \) \
    +swap -background none -layers merge +repage \
    ./Resources/BertCam/Assets.xcassets/AppIcon.appiconset/Icon-1024.png

# Array of required sizes and filenames
declare -A sizes=(
    ["20"]="Icon-20.png"
    ["40"]="Icon-20@2x.png Icon-40.png"
    ["60"]="Icon-20@3x.png"
    ["29"]="Icon-29.png"
    ["58"]="Icon-29@2x.png"
    ["87"]="Icon-29@3x.png"
    ["80"]="Icon-40@2x.png"
    ["120"]="Icon-40@3x.png Icon-60@2x.png"
    ["180"]="Icon-60@3x.png"
    ["76"]="Icon-76.png"
    ["152"]="Icon-76@2x.png"
    ["167"]="Icon-83.5@2x.png"
)

# Generate all icon sizes with high-quality resizing
cd ./Resources/BertCam/Assets.xcassets/AppIcon.appiconset
for size in "${(@k)sizes}"; do
    for filename in ${=sizes[$size]}; do
        convert Icon-1024.png -resize ${size}x${size} -quality 100 "$filename"
    done
done

echo "App icons have been generated successfully!"
