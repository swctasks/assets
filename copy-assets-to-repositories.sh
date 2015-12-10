#!/bin/bash
##############################################
##   ASSETS BUILD AND REPLICATION SCRIPT
##   FOR LOCAL USE
##
##        ++ USE WITH CAUTION !! ++
##
##############################################

bundle exec jekyll build

DIR="$( pwd )"
echo "Working from ${DIR}"
ORIGIN="${DIR}/_site/assets"
echo "Generated files at ${ORIGIN}"

STYLES="${DIR}/../styles"
STYLESFOLDER="/assets"
# REPOS=("website" "datacarpentry.github.io" "lesson-template" "workshop-template")
REPOS=("../website")
REPOSFOLDER="assets-fallback"

function copyTo {
    echo -e "\n[copyTo]"
    echo "delete existing files in ${1}"
    rm -rf $1/*
    echo "copy from $ORIGIN to ${1}"
    test -d "$1" || mkdir -p "$1"
    cp -R ${ORIGIN}/* $1
    doNotEditFilePath="${1}/_DO_NOT_EDIT_THIS_FOLDER"
    echo -e "Creating doNotEdit File at ${doNotEditFilePath}\n"
    echo '' > ${doNotEditFilePath}
    echo -e "\n${1} now contains"
    tree -R $1
    echo -e "-------------"
}

stylesAssetsPath="${STYLES}${STYLESFOLDER}"
copyTo $stylesAssetsPath

echo -e "Starting to copy in repositories"
for repo in ${REPOS[@]}; do
    repoPath="${DIR}/${repo}/${REPOSFOLDER}"
    copyTo $repoPath
done

git add -f .
git commit -m "Automatic commit after local update"
git push -fq origin gh-pages

cd ../assets

git add -f .
git commit -m "Automatic commit after local update"
git push -fq origin gh-pages
