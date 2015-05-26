wget -O http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war
rm -rf webapp
mkdir webapp
cd webapp
unzip ../ROOT.war

