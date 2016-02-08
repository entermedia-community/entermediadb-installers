
#Building x265

sudo yum install gcc make yasm perl-Digest-MD5 libX11-devel nasm 

wget http://mirror2.timburgess.net/clearos/7.1.0/contribs-testing/SRPMS/x264-0.148-25_20151019.2245.v7.src.rpm
rpm2cpio x264-0.148-25_20151019.2245.v7.src.rpm | cpio -idmv
cp x264-snapshot-20151019-2245-stable.tar.bz2 ../../../deploy/SOURCES/
cp x264-snapshot-20060912-2245-gtkincludes.patch ../../../deploy/SOURCES/
rpmbuild -ba ../specs/x264.spec




#Building Avconv

sudo yum install gcc yasm make 
sudo yum install libogg-devel libvorbis-devel x264 x264-devel libvpx-devel lame lame-devel

cp libav-11.4.tar.gz ../../../deploy/SOURCES/

rpmbuild -ba ../specs/LibAvconv.spec




#Orbis Support
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar xzvf libogg-1.3.1.tar.gz
cd libogg-1.3.1
./configure --prefix="/usr" --disable-shared
make
make install
make distclean
cd ..

#Vorbis audio encoder
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.gz
tar xzvf libvorbis-1.3.3.tar.gz
cd libvorbis-1.3.3
./configure --prefix="/usr" --with-ogg="/usr" --disable-shared
make
make install
cd ..

#Upgrade x264
wget http://download.videolan.org/pub/videolan/x264/snapshots/last_x264.tar.bz2
tar jxvf last_x264.tar.bz2
cd x264-snapshot-*
./configure --enable-shared --prefix=/usr
make
sudo make install
x264 --version
ldconfig
cd ..

#Install libvpx (for WebM)
git clone http://git.chromium.org/webm/libvpx.git
cd libvpx*
./configure
make
sudo make install
vpxenc
cd ..

#Install avconv
cp /usr/lib/pkgconfig/x264.pc /usr/lib64/pkgconfig/
ldconfig
curl "http://git.libav.org/?p=libav.git;a=snapshot;h=HEAD;sf=tgz" | tar zxv
cd libav-HEAD-*
./configure  --prefix="/usr" --enable-libx264 --enable-libfaac --enable-libmp3lame --enable-gpl --enable-nonfree --enable-libvpx --enable-libvorbis

make
make install
avconv
cd ..
cd ..

#Remove workspace
#rm -Rf avconvupgrade
