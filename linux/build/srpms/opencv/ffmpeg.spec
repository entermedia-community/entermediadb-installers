Name:          ffmpeg
Summary:       Hyper fast MPEG1/MPEG4/H263/RV and AC3/MPEG audio encoder
Version:       3.4
Release:       1%{?dist}
License:       GPLv3+
Group:         System Environment/Libraries

Source:        http://ffmpeg.org/releases/%{name}-%{version}.tar.xz
URL:           http://ffmpeg.sourceforge.net/
BuildRoot:     %{_tmppath}/%{name}-root

Provides:      ffmpeg = %{version}-%{release}

#BuildRequires: SDL-devel
#BuildRequires: a52dec-devel
BuildRequires: bzip2-devel
#BuildRequires: faad2-devel
BuildRequires: freetype-devel
BuildRequires: imlib2-devel
BuildRequires: lame-devel
BuildRequires: libstdc++-devel
BuildRequires: libvorbis-devel
BuildRequires: libtheora-devel
BuildRequires: libass-devel
BuildRequires: pulseaudio-libs-devel
BuildRequires: libv4l-devel
BuildRequires: openal-soft-devel
BuildRequires: libvpx-devel >= 1.3.0
BuildRequires: openjpeg-devel
BuildRequires: openssl-devel
BuildRequires: texi2html
BuildRequires: x264-devel
BuildRequires: x265-devel
BuildRequires: yasm
BuildRequires: zlib-devel
Requires:      %{name}-libs = %{version}-%{release}
Requires:      libass-devel

%package libs
Summary:        Library for ffmpeg
Group:          System Environment/Libraries


%package devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name}-libs = %{version}-%{release}


%description
FFmpeg is a very fast video and audio converter. It can also grab from a
live audio/video source.
The command line interface is designed to be intuitive, in the sense that
ffmpeg tries to figure out all the parameters, when possible. You have
usually to give only the target bitrate you want. FFmpeg can also convert
from any sample rate to any other, and resize video on the fly with a high
quality polyphase filter.

%description devel
FFmpeg is a complete and free Internet live audio and video broadcasting
solution for Linux/Unix. It also includes a digital VCR. It can encode in real
time in many formats including MPEG1 audio and video, MPEG4, h263, ac3, asf,
avi, real, mjpeg, and flash.
This package contains development files for ffmpeg

%description libs
FFmpeg is a complete and free Internet live audio and video broadcasting
solution for Linux/Unix. It also includes a digital VCR. It can encode in real
time in many formats including MPEG1 audio and video, MPEG4, h263, ac3, asf,
avi, real, mjpeg, and flash.
This package contains the libraries for ffmpeg



%prep
%setup -q -n %{name}-%{version}
test -f version.h || echo "#define FFMPEG_VERSION \"%{evr}\"" > version.h

%build
./configure --prefix=%{_prefix} --libdir=%{_libdir} \
            --shlibdir=%{_libdir} --mandir=%{_mandir} \
   --enable-shared \
   --disable-static \
   --enable-runtime-cpudetect \
   --enable-gpl \
   --enable-version3 \
   --enable-postproc \
   --enable-avfilter \
   --enable-pthreads \
   --enable-libmp3lame \
   --enable-libopenjpeg \
   --enable-libtheora \
   --enable-bzlib \
   --enable-libass \
   --enable-libfreetype \
   --enable-openal \
   --enable-libpulse \
   --enable-libv4l2 \
   --disable-debug \
   --enable-libvorbis \
   --enable-libvpx \
   --enable-libx264 \
   --enable-libx265 \


make
pushd doc
rm -f general.html.d platform.html.d git-howto.html.d \
   developer.html.d texi2pod.pl faq.html.d
popd


%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot} incdir=%{buildroot}%{_includedir}/ffmpeg
rm -f doc/Makefile
rm -f %{buildroot}/usr/share/doc/ffmpeg/*.html


%clean
rm -rf %{buildroot}


%post libs -p /sbin/ldconfig
%postun libs -p /sbin/ldconfig


%files
%defattr(-,root,root,-)
%doc COPYING* CREDITS README* MAINTAINERS LICENSE* RELEASE doc/ RELEASE_NOTES VERSION
%{_bindir}/*
%{_datadir}/ffmpeg
%{_mandir}/man1/*


%files libs
%defattr(-,root,root,-)
%doc COPYING* CREDITS README* MAINTAINERS LICENSE* RELEASE doc/ RELEASE_NOTES VERSION
%{_libdir}/*.so.*
%{_mandir}/man3/*


%files devel
%defattr(-,root,root,-)
%doc COPYING* CREDITS README* MAINTAINERS LICENSE* RELEASE doc/ RELEASE_NOTES VERSION
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc
%{_libdir}/*.so


%changelog
* Thu Oct 26 2017 Eduardo Cruz Reyes <ecruzreyes@linux.com> - 3.4
- Dependency cleanup
- Update to FFmpeg 3.4
