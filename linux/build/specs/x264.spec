%bcond_with gtk
%bcond_with gpac

%global x264lib 148
%{?with_gtk:%global x264gtklib 148}

Summary: A free h264/avc encoder
Name: x264
Version: 0.148
%define pkgversion 20151019-2245
Release: 25_20151019.2245%{?dist}
License: GPL
Group: System Environment/Libraries
URL: http://www.videolan.org/developers/x264.html
Source0: ftp://ftp.videolan.org/pub/videolan/x264/snapshots/%{name}-snapshot-%{pkgversion}-stable.tar.bz2
Patch0: x264-snapshot-20060912-2245-gtkincludes.patch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: libX11-devel
%{?with_gpac:BuildRequires: gpac-devel}
BuildRequires: nasm, yasm, %{?with_gtk:gtk2-devel}
BuildRequires: gettext
BuildRequires: perl(Digest::MD5)
Requires: x264-libs_%{x264lib}

%description
x264 is a free library for encoding H264/AVC video streams.

%package libs_%{x264lib}
Summary: Library for encoding H264/AVC video streams.
Group: Development/Libraries
Obsoletes: libx264_%{x264lib}

%description libs_%{x264lib}
Shared libraries for the x264 package.

%package devel
Summary: Development files for the x264 library.
Group: Development/Libraries

%description devel
x264 development headers and libraries.

%prep
%setup -q -n %{name}-snapshot-%{pkgversion}-stable
#patch0 -p1 -b .gtkincludes
perl -pi -e's, -lintl,,' gtk/Makefile
grep -rl /usr/X11R6/lib . | xargs perl -pi -e's,/usr/X11R6/lib,%{_x_libraries},'

%build
%configure \
  %{?with_gpac:--enable-mp4-output} \
  %{?with_gtk:--enable-gtk} \
  --enable-pthread \
  --enable-visualize \
  --enable-pic \
  --enable-shared \
  --extra-cflags="%{optflags}"
make

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_includedir} %{buildroot}%{_libdir}/pkgconfig \
  %{buildroot}%{_bindir}
make install DESTDIR=%{buildroot}
%{?with_gtk:%find_lang x264_gtk}

%post libs_%{x264lib} -p /sbin/ldconfig

%postun libs_%{x264lib} -p /sbin/ldconfig

%clean
rm -rf %{buildroot}

%files devel
%{_includedir}/x264.h
%{_includedir}/x264_config.h
%{_libdir}/libx264.so
%{_libdir}/pkgconfig/x264.pc

%files libs_%{x264lib}
%{_libdir}/libx264.so.%{x264lib}

%files %{?with_gtk:-f x264_gtk.lang}
%defattr(-,root,root,-)
%doc COPYING AUTHORS doc/*.txt
%{_bindir}/*
%{?with_gtk:%{_datadir}/x264/x264.png}

%changelog
* Tue Oct 20 2015 Fredrik Fornstad <fredrik.fornstad@gmail.com> - 0.148-25_20151019.2245
- Updated upstream to latest stable snapshot

* Tue Jul 28 2015 Fredrik Fornstad <fredrik.fornstad@gmail.com> - 0.146-24_20150727.2245
- Updated upstream to latest stable snapshot

* Sat Jun 13 2015 Fredrik Fornstad <fredrik.fornstad@gmail.com> - 0.144-2533_1
- Removed dependency of atrpms to comply with ClearOS policy
- Updated upstream to latest stable from Git
- Added post and postun ldconfig

* Wed May 6 2015 Fredrik Fornstad <fredrik.fornstad@gmail.com> - 0.142-22_20141218.2245
- Added buildrequirement atrpms-rpm-config

* Sat May 2 2015 Fredrik Fornstad <fredrik.fornstad@gmail.com> - 0.142-21_20141218.2245
- Update to latest stable snapshot.

* Mon Apr  7 2014 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.142-20_20140406.2245
- Update to latest stable snapshot.

* Fri Nov 15 2013 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.138-19_20130917.2245
- Update to latest stable snapshot.

* Wed Sep 18 2013 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.136-19_20130917.2245
- Update to latest stable snapshot.

* Fri May 10 2013 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.130-18_20130509.2245
- Update to latest stable snapshot.

* Sat Nov 12 2011 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.118-17_20111111.2245
- Update to latest stable snapshot.

* Sat Jun 11 2011 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.115-16_20110610.2245
- Update to latest stable snapshot.

* Wed Mar  9 2011 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.114-15_20110308.2245
- Update to latest stable snapshot.

* Sat Oct  2 2010 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.106-13_20101001.2245
- Update to latest git.

* Tue Jun 22 2010 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.98-12_20100621.2245
- Update to latest git.

* Thu Apr  1 2010 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.92-12_20100401.2245
- Update to latest git.

* Fri Nov 20 2009 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.79-11_20091119.2245
- Update to latest git.

* Mon Jul 20 2009 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.68-10_20090719.2245
- Update to latest git.

* Sun Nov 16 2008 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.65-8_20081108.2245
- x264-libs from a 3rd party repo generates conflicts.

* Sun Nov  9 2008 Axel Thimm <Axel.Thimm@ATrpms.net> - 0.65-6_20081108.2245
- Update to latest git.

* Fri Jun 27 2008 Axel Thimm <Axel.Thimm@ATrpms.net> - svn20080626_2245-5
- Update to latest git.

* Tue Feb 26 2008 Axel Thimm <Axel.Thimm@ATrpms.net> - svn20080225_2245-5
- Update to latest svn.

* Sun Apr 15 2007 Axel Thimm <Axel.Thimm@ATrpms.net> - svn20070414_2245-4
- Update to latest svn.

* Wed Feb  7 2007 Axel Thimm <Axel.Thimm@ATrpms.net> - svn20070206_2245-3
- Update to latest svn.

* Wed Jan  3 2007 Axel Thimm <Axel.Thimm@ATrpms.net> - svn20070102_2245-2
- Update to latest svn.

* Wed Sep 13 2006 Axel Thimm <Axel.Thimm@ATrpms.net> - svn20060912_2245-1
- Initial build.

