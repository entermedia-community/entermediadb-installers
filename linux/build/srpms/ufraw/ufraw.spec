
%if 0%{?fedora}%{?rhel} == 0 || 0%{?fedora} >= 6 || 0%{?rhel} >= 5
%bcond_without splitpackage
%else
%bcond_with splitpackage
%endif

%if 0%{?fedora}%{?rhel} == 0 || 0%{?fedora} >= 8 || 0%{?rhel} >= 5
%bcond_without pkg_mime_xml
%else
%bcond_with pkg_mime_xml
%endif

%if %{with splitpackage}
%define spkg 1
%endif

%define gimptool %{_bindir}/gimptool-2.0
%define gimpplugindir %(%gimptool --gimpplugindir)/plug-ins


Summary: Raw image data retrieval tool for digital cameras
Name: ufraw
Version: 0.22
Release: 1%{?dist}
Group: Applications/Multimedia
License: GPLv2+
URL: http://ufraw.sourceforge.net
Source0: http://downloads.sourceforge.net/ufraw/ufraw-%{version}.tar.gz
BuildRequires: gimp-devel >= 2.2
BuildRequires: gimp >= 2.2
BuildRequires: glib2-devel >= 2.12
BuildRequires: gtk2-devel >= 2.12
BuildRequires: lcms2-devel
BuildRequires: libexif-devel >= 0.6.13
BuildRequires: exiv2-devel >= 0.18.1
BuildRequires: lensfun-devel >= 0.2.5
BuildRequires: libtiff-devel 
BuildRequires: libjpeg-devel
BuildRequires: pkgconfig >= 0.9.0
BuildRequires: perl
BuildRequires: gettext
BuildRequires: cfitsio-devel
Requires(post): desktop-file-utils
Requires(postun): desktop-file-utils
%if %{with splitpackage}
Requires: ufraw-common = %{?epoch:%{epoch}:}%{version}-%{release}
%else
Requires: gimp%{?_isa}
%if ! %{with cinepaint}
Obsoletes: %{name}-cinepaint < 0.19.2-4
%endif
Requires(post): GConf2
Requires(preun): GConf2
%if %{with pkg_mime_xml}
Requires(post): shared-mime-info < 0.21
Requires(postun): shared-mime-info < 0.21
%else
Requires(post): shared-mime-info >= 0.21
Requires(postun): shared-mime-info >= 0.21
%endif
%endif

Provides: bundled(dcraw)

#BuildRequires: automake libtool

%description
UFRaw is a tool for opening raw format images of digital cameras.

%if %{with splitpackage}
%package common
Summary: Common files needed by UFRaw
Group: Applications/Multimedia
Requires(post): GConf2
Requires(preun): GConf2
Requires(post): shared-mime-info
Requires(postun): shared-mime-info

%description common
The ufraw-common files includes common files for UFRaw, e.g. language support.


%endif

%prep
cat << EOF

Building UFRaw with these settings:
cinepaint:      %{with cinepaint}
splitpackage:   %{with splitpackage}
pkg_mime_xml:   %{with pkg_mime_xml}

EOF
%setup -q

%build
%configure --with-gtk=no --prefix=/usr  --enable-mime --enable-extras --enable-contrast --disable-silent-rules

make schemasdir=%{_sysconfdir}/gconf/schemas

%install
make DESTDIR=%buildroot schemasdir=%{_sysconfdir}/gconf/schemas install
# don't ship dcraw binary
rm -f %{buildroot}%{_bindir}/dcraw
%if %{with pkg_mime_xml}
install -d -m 0755 %buildroot%{_datadir}/mime/packages
install -m 0644 ufraw-mime.xml %buildroot%{_datadir}/mime/packages
%endif
pushd %{buildroot}%{_mandir}/man1
ln -s ufraw.1 ufraw-batch.1
popd

%find_lang %{name}

%post %{?spkg:common}
export GCONF_CONFIG_SOURCE=`gconftool-2 --get-default-source`
gconftool-2 --makefile-install-rule %{_sysconfdir}/gconf/schemas/ufraw.schemas >& /dev/null || :
%if %{with pkg_mime_xml}
touch --no-create %{_datadir}/mime/packages &> /dev/null || :
%endif
%if %{with splitpackage}
%post
%endif
update-desktop-database >& /dev/null || :

%preun %{?spkg:common}
export GCONF_CONFIG_SOURCE=`gconftool-2 --get-default-source`
gconftool-2 --makefile-uninstall-rule /etc/gconf/schemas/ufraw.schemas >& /dev/null || :

%postun %{?spkg:common}
%if %{with pkg_mime_xml}
if [ $1 -eq 0 ] ; then
touch --no-create %{_datadir}/mime/packages &> /dev/null || :
update-mime-database %{?fedora:-n} %{_datadir}/mime &> /dev/null || :
fi
%endif
%if %{with splitpackage}
%postun
%endif
update-desktop-database >& /dev/null || :

%if %{with pkg_mime_xml}
%posttrans %{?spkg:common}
update-mime-database %{?fedora:-n} %{_datadir}/mime &> /dev/null || :
%endif

%files %{?spkg:common} -f %{name}.lang
%defattr(-, root, root, -)
%doc COPYING README
%if %{with pkg_mime_xml}
%{_datadir}/mime/packages/ufraw-mime.xml
%endif
%{_sysconfdir}/gconf/schemas/ufraw.schemas

%if %{with splitpackage}
%files
%defattr(-, root, root, -)
%endif
%{_bindir}/*
%{_datadir}/pixmaps/*
%{_datadir}/applications/*.desktop
%{_datadir}/appdata/*.appdata.xml
%{_mandir}/man1/*



%changelog
* Thu May 21 2015 Nils Philippsen <nils@redhat.com> - 0.21-1
- avoid writing past array boundaries when reading certain raw formats
  (CVE-2015-3885)

* Wed May 20 2015 Nils Philippsen <nils@redhat.com> - 0.21-1
- version 0.21
- don't manually specify, clean buildroot
- add Provides: bundled(dcraw)

* Thu May 14 2015 Nils Philippsen <nils@redhat.com> - 0.20-4
- rebuild for lensfun-0.3.1

* Wed May 13 2015 Nils Philippsen <nils@redhat.com> - 0.20-3
- rebuild for lensfun-0.3.0

* Sat May 02 2015 Kalev Lember <kalevlember@gmail.com> - 0.20-2
- Rebuilt for GCC 5 C++11 ABI change

* Tue Oct 07 2014 Nils Philippsen <nils@redhat.com> - 0.20-1
- version 0.20

* Mon Aug 18 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.19.2-16.20140414cvs
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_22_Mass_Rebuild

* Sat Aug 09 2014 Rex Dieter <rdieter@fedoraproject.org> 0.19.2-15.20140414cvs
- optimize mime scriptlet, %%configure --disable-silent-rules

* Sun Jun 08 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.19.2-14.20140414cvs
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Tue Apr 29 2014 Nils Philippsen <nils@redhat.com> - 0.19.2-13
- fix tweaking color temperature, green value based off camera WB

* Sat Apr 26 2014 Nils Philippsen <nils@redhat.com> - 0.19.2-12
- snapshot cvs20140414: fixes using camera white balance with Sony SLT-A99V

* Fri Jan 10 2014 Orion Poplawski <orion@cora.nwra.com> - 0.19.2-11
- Rebuild for cfitsio 3.360

* Fri Dec 06 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-10
- harden against corrupt input files (CVE-2013-1438)

* Tue Dec 03 2013 Rex Dieter <rdieter@fedoraproject.org> 0.19.2-9
- rebuild (exiv2)

* Sat Oct 05 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-8
- actually require lcms2-devel for building
- update lcms2 patch so that it builds with lcms2 < 2.5

* Wed Oct 02 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-7
- build against lcms2
- drop obsolete configure options (exiv2, lensfun, libexif)

* Thu Sep 19 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-6
- fix disabling cinepaint subpackage from F-20 on (#986689)

* Fri Sep 13 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-6
- drop ancient obsoletes (#1002124)

* Fri Sep 13 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-5
- gimp plug-in:
  - decode EXIF into XMP
  - register TIFF and XML file loader magic values to fix loading raw files in
    and sending images to upcoming GIMP versions

* Wed Jul 31 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-4
- don't own plug-in directories (#989890)
- install symlinked ufraw-batch man page

* Mon Jul 29 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-3
- disable cinepaint subpackage from F-20 on (#986689)
- rebuild for newer cfitsio

* Sat May 11 2013 Rex Dieter <rdieter@fedoraproject.org> 0.19.2-2.1
- rebuild for newer lensfun (#947988)

* Wed Mar 27 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-2
- upstream rolled new tarball supporting aarch64

* Mon Mar 25 2013 Nils Philippsen <nils@redhat.com> - 0.19.2-1
- version 0.19.2
- enable building on aarch64

* Sun Mar 24 2013 Peter Robinson <pbrobinson@fedoraproject.org> 0.19-2
- rebuild (libcfitsio)

* Fri Mar 01 2013 Nils Philippsen <nils@redhat.com> - 0.19-1
- version 0.19
- drop obsolete patches

* Fri Feb 15 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.18-17
- Rebuilt for https://fedoraproject.org/wiki/Fedora_19_Mass_Rebuild

* Mon Jan 21 2013 Adam Tkac <atkac redhat com> - 0.18-16
- rebuild due to "jpeg8-ABI" feature drop

* Fri Dec 21 2012 Adam Tkac <atkac redhat com> - 0.18-15
- rebuild against new libjpeg

* Sat Sep 08 2012 Nils Philippsen <nils@redhat.com> - 0.18-14
- fix trimming excessive EXIF data

* Sun Jul 22 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.18-13
- Rebuilt for https://fedoraproject.org/wiki/Fedora_18_Mass_Rebuild

* Wed May 02 2012 Rex Dieter <rdieter@fedoraproject.org> - 0.18-12
- rebuild (exiv2)

* Mon Apr 16 2012 Nils Philippsen <nils@redhat.com> - 0.18-11
- rebuild for new cinepaint

* Tue Apr 03 2012 Nils Philippsen <nils@redhat.com> - 0.18-10
- rebuild against gimp 2.8.0 release candidate

* Fri Mar 16 2012 Nils Philippsen <nils@redhat.com> - 0.18-9
- use new GIMP 2.8 API if available

* Tue Feb 28 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.18-8
- Rebuilt for c++ ABI breakage

* Tue Jan 10 2012 Nils Philippsen <nils@redhat.com> - 0.18-7
- rebuild for gcc 4.7

* Fri Dec 16 2011 Nils Philippsen <nils@redhat.com> - 0.18-6
- rebuild for GIMP 2.7

* Mon Nov 07 2011 Nils Philippsen <nils@redhat.com> - 0.18-5
- rebuild (libpng)

* Fri Oct 14 2011 Rex Dieter <rdieter@fedoraproject.org> - 0.18-4
- rebuild (exiv2)

* Fri Aug 12 2011 Nils Philippsen <nils@redhat.com> - 0.18-3
- fix crop area ratios if working on multiple images (#634235, patch by Udi
  Fuchs)

* Tue Mar 15 2011 Nils Philippsen <nils@redhat.com> - 0.18-2
- fix crash when loading dark frame (#683199)

* Fri Mar 04 2011 Nils Philippsen <nils@redhat.com> - 0.18-1
- version 0.18
- add/update versioned build requirements

* Mon Feb 07 2011 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.17-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_15_Mass_Rebuild

* Sun Jan 02 2011 Rex Dieter <rdieter@fedoraproject.org> - 0.17-3
- rebuild (exiv2)

* Fri Dec 03 2010 Nils Philippsen <nils@redhat.com> - 0.17-2
- rebuild (exiv2)

* Wed Jun 02 2010 Nils Philippsen <nils@redhat.com> - 0.17-1
- version 0.17
- add BR: cfitsio-devel

* Mon May 31 2010 Rex Dieter <rdieter@fedoraproject.org> - 0.16-3 
- rebuild (exiv2)

* Mon Jan 04 2010 Rex Dieter <rdieter@fedoraproject.org> - 0.16-2 
- rebuild (exiv2)

* Sat Dec 05 2009 Dennis Gilmore <dennis@ausil.us> - 0.16-1
- update to 0.16

* Mon Aug 17 2009 Nils Philippsen <nils@redhat.com> - 0.15-4
- fix building with lensfun (#517558), only build with lensfun from F-12 on
- explain gcc-4.4 patch

* Sun Jul 26 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.15-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_12_Mass_Rebuild

* Mon Mar 02 2009 Nils Philippsen <nils@redhat.com> - 0.15-2
- fix building with gcc-4.4

* Wed Feb 25 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org>
- Rebuilt for https://fedoraproject.org/wiki/Fedora_11_Mass_Rebuild

* Mon Jan 26 2009 Nils Philippsen <nils@redhat.com> - 0.15-1
- version 0.15:
  - Multiprocessing support using OpenMP. Patch by Bruce Guenter.
  - Add progress report during the loading of raw files.
  - Add JPEG optimization to reduce the file size without effecting image
    quality.
  - Compatibility with the just released Exiv2-0.18.
  - Support sRAW1 and sRAW2 formats of the Canon 50D and 5D Mark II.
  - Some annoying bugs got squashed.
- use downloads.sourceforge.net source URL

* Thu Dec 18 2008 Rex Dieter <rdieter@fedoraproject.org> - 0.14.1-4 
- respin (exiv2)

* Tue Dec 02 2008 Nils Philippsen <nils@redhat.com> - 0.14.1-3
- require gimp and cinepaint in the respective subpackages (#474021)

* Mon Dec 01 2008 Nils Philippsen <nils@redhat.com> - 0.14.1-2
- change license to GPLv2+

* Fri Nov 28 2008 Nils Philippsen <nils@redhat.com> - 0.14.1-1
- version 0.14.1
- use %%bcond_with/without macros
- enable building with lensfun from F11 on

* Fri Jul 04 2008 Nils Philippsen <nphilipp@redhat.com> - 0.13-6
- rebuild with gtkimageview-1.6.1

* Wed Jun 25 2008 Rex Dieter <rdieter@fedoraproject.org> - 0.13-5 
- respin for exiv2

* Tue Feb 19 2008 Fedora Release Engineering <rel-eng@fedoraproject.org> - 0.13-4
- Autorebuild for GCC 4.3

* Wed Jan 02 2008 Nils Philippsen <nphilipp@redhat.com> - 0.13-3
- build against gtkimageview, drop scrollable-preview patch (#427028)

* Fri Nov 30 2007 Nils Philippsen <nphilipp@redhat.com> - 0.13-2
- make preview scrollable, window resizable

* Fri Nov 30 2007 Nils Philippsen <nphilipp@redhat.com> - 0.13-1
- version 0.13
- build cinepaint plugin from Fedora 7 on (#282641)

* Wed Nov 14 2007 Nils Philippsen <nphilipp@redhat.com> - 0.12-3
- rephrase summary
- use full path to gimptool

* Wed Sep 05 2007 Nils Philippsen <nphilipp@redhat.com> - 0.12-2
- change license to GPLv2

* Mon Aug 06 2007 Nils Philippsen <nphilipp@redhat.com> - 0.12-1
- version 0.12
- drop obsolete exiv2, cmserrorhandler patches
- package ufraw-mime.xml for up to Fedora 7, RHEL 5

* Thu May 24 2007 Nils Philippsen <nphilipp@redhat.com> - 0.11-8
- use correct patch

* Thu May 24 2007 Nils Philippsen <nphilipp@redhat.com> - 0.11-7
- prevent crash in CMS error handler (#239147)

* Wed Apr 25 2007 Rex Dieter <rdieter[AT]fedoraproject> - 0.11-6
- exiv2 patch (#237846)

* Wed Apr 25 2007 Rex Dieter <rdieter[AT]fedoraproject> - 0.11-5
- respin for exiv2-0.14

* Tue Apr 24 2007 Nils Philippsen <nphilipp@redhat.com> - 0.11-4
- eventually put GConf2, shared-mime-info requirements into -common subpackage
  (#235583)

* Mon Mar 12 2007 Nils Philippsen <nphilipp@redhat.com> - 0.11-3
- split pkg from fc6/rhel5 on to avoid upgrading mess

* Mon Mar 12 2007 Nils Philippsen <nphilipp@redhat.com> - 0.11-2
- use %%rhel, not %%redhat

* Mon Mar 12 2007 Nils Philippsen <nphilipp@redhat.com> - 0.11-1
- version 0.11

* Mon Feb 19 2007 Nils Philippsen <nphilipp@redhat.com> - 0.10-2
- don't ship dcraw binary (#229044)

* Wed Feb 07 2007 Nils Philippsen <nphilipp@redhat.com> - 0.10-1
- version 0.10
- add BR: perl, exiv2-devel, gettext
- split standalone tools and GIMP plugin in Rawhide

* Mon Aug 28 2006 Nils Philippsen <nphilipp@redhat.com> - 0.9.1-1
- version 0.9.1
- require gimp >= 2.0 for building

* Fri Feb 17 2006 Nils Philippsen <nphilipp@redhat.com> - 0.6-2
- rebuild

* Mon Nov 21 2005 Nils Philippsen <nphilipp@redhat.com> - 0.6-1
- version 0.6

* Thu Oct 06 2005 Nils Philippsen <nphilipp@redhat.com> - 0.5-1
- version 0.5

* Sun May 22 2005 Jeremy Katz <katzj@redhat.com> - 0.4-2
- rebuild to sync arches

* Tue Mar 29 2005 Seth Vidal <skvidal at phy.duke.edu> - 0.4-1
- buildrequire libtiff-devel and libjpeg-devel

* Thu Mar 24 2005 Nils Philippsen <nphilipp@redhat.com> - 0.4-1
- buildrequire lcms-devel
- trim summary
- change buildroot

* Wed Mar 02 2005 Nils Philippsen <nphilipp@redhat.com>
- version 0.4
- update URLs

* Wed Dec 01 2004 Nils Philippsen <nphilipp@redhat.com>
- version 0.2
- initial build
