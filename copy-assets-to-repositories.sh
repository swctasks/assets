#!/bin/bash
##############################################
##   ASSETS BUILD AND REPLICATION SCRIPT
##   FOR LOCAL USE
##   RUN FROM "ASSETS" FOLDER
##
##        ++ USE WITH CAUTION !! ++
##
##############################################

#echo -n "With push? ('y' will push other no) [ENTER]: "
#read doPush

bundle exec jekyll build

DIR="$( pwd )"
echo "Working from ${DIR}"
ORIGIN="${DIR}/_site/assets"
echo "Generated files at ${ORIGIN}"

STYLES="/../styles"
STYLESFOLDER="assets"

#REPOS=("/../website" "/../datacarpentry.github.io" "/../lesson-template" "/../workshop-template")
REPOS=("/../workshop-template")

ASSETSFOLDER="assets-fallback"

function copyTo {
    echo "[copyTo]"
    echo "Parameter #1 is $1 - Parameter #2 is $2 - Parameter #3 is $3"
    cd $DIR
    echo "currently in $(pwd)"
    targetRepo="${DIR}${1}"
    assetsDestination="${targetRepo}/${2}"
    echo "deleting existing files from ${assetsDestination}"
    rm -rf $assetsDestination/*
    echo "copy from $ORIGIN to ${assetsDestination}"
    test -d "$assetsDestination" || mkdir -p "$assetsDestination"
    cp -R ${ORIGIN}/* $assetsDestination
    doNotEditFilePath="${assetsDestination}/_DO_NOT_EDIT_THIS_FOLDER"
    echo "Creating doNotEdit File at ${doNotEditFilePath}"
    echo '' > ${doNotEditFilePath}
    echo "${assetsDestination} now contains"
#    tree -R $assetsDestination
    echo -e " -- Committing results from ${targetRepo}"
    cd $targetRepo
    echo "currently in $(pwd)"

    if [ -z $(git status --porcelain) ]
        then
            echo "Nothing to commit"
        else
            echo "Commiting"
            git add -fA "./$2"
            git commit -m "Automatic commit after local update"

            echo "Pushing"
            git pull origin gh-pages
            git push -fq origin gh-pages
    fi
    echo -e "-------------\n"
}

copyTo $STYLES $STYLESFOLDER "true"

echo -e "Starting to copy in repositories"
for repo in ${REPOS[@]}; do
    copyTo $repo $ASSETSFOLDER "false"
done
