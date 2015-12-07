#!/usr/bin/env sh

# The -e flag causes the script to exit as soon as one command returns a non-zero exit code
# The -v flag makes the shell print all lines in the script before executing them, which helps identify which steps failed.
set -ev

echo TRAVIS_TEST_RESULT : $TRAVIS_TEST_RESULT

# test if the build is not from a pull request
if [ "$TRAVIS_PULL_REQUEST" == false ]; then
  echo -e "Starting to update script repository with an assets repository build result\n"

  #copy data we're interested in to other place
  cp -R _site/assets $HOME/assets

  #go to home and setup git
  cd $HOME

  echo GIT_NAME: $GIT_NAME
  echo GIT_EMAIL: $GIT_EMAIL

  git config --global user.email $GIT_EMAIL
  git config --global user.name $GIT_NAME

  GH_TOKEN = "obj9zs4GxlnbTToUh+bueEMxmrq+WEM5xYN7ZPzYKw5msEq51RlsvtM3rH2R0eYTY+UCsZCFUsCoL5Gtyf9/dfQgmWU39x391vuewoUbPR77dI1CxBYINskTxu71z4MLJnctIIYzG3TuhIwgIQDNP9V6iNSWJD7p3VrjoiZTM+VaWdYBsx+9iiq9f5r73iC3ShomevI+ldeSdkgtUvgnYykmiX3DSKqdXko4DQczzpTL8sMQqM0qiCVYBp0F9XmVs0khYNl0c9DKu6Gxy7YUfqxM2ZJWUQMb8HYUWUmCJue66+khSjuaO17cNwV1N9y0sWtHLGcLZqjQLTWIHCORE9Sk6JdAooPpQodURQMZFoG9oKOjLRJOA7U8HZTkEIsVy53Dg0B69dXBXS8WfGRVBasYggLDBmBydQ4vT4S/CkljRSH2D+kCdE9q021WlqvydmpsikguTrwENi/S0RVv/NB0mczCwAlxc1HP7pfNiE/ODtHvycLg+pz6Izh9B0NdsP8YOEWnYAm2l8JyEQykzUS1nR54+MwxGasLMQ1dkElIMkOrFOUYZqnyM76evu7NVpgxXM19pFViLTX8hQ6N6rSBu7BTQ0v3w3Gy+OgHCbnLMYRLoxViygtISB3VSyLdbBPknhaWOvwZ7Cyb8xPwFS1ITYXkcN2kcmty2A8GwaY="
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
