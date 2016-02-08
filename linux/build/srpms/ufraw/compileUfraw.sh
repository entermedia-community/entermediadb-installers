#!/bin/bash -x
CWD=$(pwd)
source ../../functions.sh

if [ ! -f "~/.rpmmacros" ]; then
        echoWhite -n "rpmmacros not found, creating... "
        echo "%_topdir ${TOPLEVEL}" > ~/.rpmmacros
        echo "%debug_package %{nil}" >> ~/.rpmmacros
fi


#http://ufraw.sourceforge.net/Install.html

#tar xzf ufraw-0.22.tar.gz & cd ufraw-0.22
#./configure --with-gtk=no --prefix=/usr 
#sudo make
#sudo make install



cp ufraw-0.22.tar.gz  ${TOPLEVEL}/SOURCES
cp ufraw.spec ${TOPLEVEL}/SPECS

rpmbuild -bs -vv ${TOPLEVEL}/SPECS/ufraw.spec
sudo yum-builddep -v ${TOPLEVEL}/SRPMS/ufraw-0.22-1.el7.centos.src.rpm
rpmbuild --rebuild -vv ${TOPLEVEL}/SRPMS/ufraw-0.22-1.el7.centos.src.rpm

