#Do not use this for building. Use the script on the dev server jenkins
PLATFORM=$1
BRANCH=$2
set -x -e 
cd build
./makerpm.sh 1015 $PLATFORM $BRANCH
scp ../../deploy/RPMS/x86_64/*.rpm emdev@woody.entermediadb.net:/home/emdev/webapp/repo/$PLATFORM/6/x86_64/rpms
scp ../../deploy/RPMS/x86_64/*.rpm emdev@woody.entermediadb.net:/home/emdev/webapp/repo/$PLATFORM/7/x86_64/rpms
ssh emdev@woody.entermediadb.net "/home/emdev/webapp/repo/make${PLATFORM}.sh"

