#!/bin/bash

# The -e flag causes the script to exit as soon as one command returns a non-zero exit code
# The -v flag makes the shell print all lines in the script before executing them, which helps identify which steps failed.
set -ev

echo TRAVIS_TEST_RESULT : $TRAVIS_TEST_RESULT

# test if the build is not from a pull request
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  echo -e "Starting to update script repository with an assets repository build result\n"

  #copy data we're interested in to other place
  cp -R _site/assets $HOME/assets

  #go to home and setup git
  cd $HOME

  echo GIT_NAME: $GIT_NAME
  echo GIT_EMAIL: $GIT_EMAIL

  git config --global user.email $GIT_EMAIL
  git config --global user.name $GIT_NAME

  #using token clone gh-pages branch
  # please note that some output is redirected to /dev/null to avoid leaking of decrypted token.
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/swctasks/styles.git  styles # > /dev/null

  #go into diractory and copy data we're interested in to that directory
  cd styles
  cp -Rf $HOME/assets/* .

  #add, commit and push files
  git add -f .
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER from assets repository"
  git push -fq origin gh-pages # > /dev/null

  echo -e "Done magic with assets\n"
fi
