cd ../../deploy/SOURCES
wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.1-9.tar.bz2
cd ..
rpmbuild -bs SPECS/ImageMagick.spec
sudo yum-builddep ImageMagick-6.9.1-9.src.rpm 
rpmbuild --rebuild ImageMagick-6.9.1-9.src.rpm 

