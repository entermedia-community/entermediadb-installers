wget http://dev.entermediasoftware.com/jenkins/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war
rm -rf webapp
mkdir webapp
cd webapp
unzip ../ROOT.war
rm ../ROOT.war
