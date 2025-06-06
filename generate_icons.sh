#!/bin/zsh

# Create base icon with camera symbol
convert -size 1024x1024 xc:none -fill '#007AFF' -draw 'circle 512,512 512,912' -draw 'circle 512,512 512,412' ./Resources/BertCam/Assets.xcassets/AppIcon.appiconset/Icon-1024.png

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

# Generate all icon sizes
cd ./Resources/BertCam/Assets.xcassets/AppIcon.appiconset
for size in "${(@k)sizes}"; do
    for filename in ${=sizes[$size]}; do
        convert Icon-1024.png -resize ${size}x${size} "$filename"
    done
done
