#!/bin/bash


function prepare() {
    local MAPS_API_KEY=$(grep "MAPS_API_KEY" .env | cut -d '=' -f2)
    sed -i "s/MAPS_API_KEY/$MAPS_API_KEY/g" ./android/app/src/main/AndroidManifest.xml
}

function clean() {
    local MAPS_API_KEY=$(grep "MAPS_API_KEY" ./client/.env | cut -d '=' -f2)
    sed -i "s/$MAPS_API_KEY/MAPS_API_KEY/g" ./client/android/app/src/main/AndroidManifest.xml
    git add ./client/android/app/src/main/AndroidManifest.xml
}

if [ "$1" == "prepare" ]; then
    prepare
elif [ "$1" == "clean" ]; then
    clean
fi