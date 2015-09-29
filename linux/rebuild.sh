#Do not use this for building. Use the script on the dev server jenkins
PLATFORM=$1
BRANCH=$2
set -x -e 
cd build
./makerpm.sh 1015 $PLATFORM $BRANCH

