wget ftp://ftp.pbone.net/mirror/li.nux.ro/download/nux/dextop/el7Client/SRPMS/ufraw-0.20-1.el7.nux.src.rpm
yum -y install rpmdevtools yasm wget cmake gcc gcc-c++
yum deplist ufraw-0.20-1.el7.nux.src.rpm 
yum install gimp-devel gimp glib2-devel gtk2-devel gtkimageview-devel lcms2-devel libexif-devel  exiv2-devel lensfun-devel  libtiff-devel libjpeg-devel pkgconfig  perl gettext cfitsio-devel rpmlib
wget ftp://ftp.pbone.net/mirror/li.nux.ro/download/nux/dextop/el7/x86_64/gtkimageview-devel-1.6.4-8.el7.nux.x86_64.rpm
yum install gtkimageview-devel-1.6.4-8.el7.nux.x86_64.rpm 
yum install gtkimageview-devel
rpmbuild --rebuild ufraw-0.20-1.el7.nux.src.rpm
yum install /root/rpmbuild/RPMS/x86_64/ufraw-0.20-1.el7.x86_64.rpm

