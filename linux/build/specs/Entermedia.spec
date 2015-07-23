#
# Entermedia Spec file...
#

Summary:	EnterMediaDB Media Database
Name: 		entermediadb
Version: 	8.19
Release:	10
License: 	GPL
URL:		https://github.com/entermedia-community
Vendor: 	EnterMedia Software, Inc.
BuildRoot: 	%{_tmppath}/%{name}-root
Requires: 	java-1.8.0-openjdk  lame ImageMagick libav perl-Image-ExifTool ghostscript gimp libreoffice libGL
Source0: 	entermediadb-%{version}.tar.gz
BuildArch: 	x86_64



%description
EnterMedia is an Open Source Media Database that empowers you to take control of managing every aspect of digital assets by providing developers with powerful API’s to build custom applications, and providing users with an intuitive front end that can be rearranged and personalized for specific needs. Our flexible and proven platform allows users to centralize, secure, and share content, manage workflow, and track details and changes throughout the system.

%define __os_install_post %{nil}

%prep
%setup
%build
%pre

%install
rm -rf ${RPM_BUILD_ROOT}
mkdir -p ${RPM_BUILD_ROOT}
cp -rp * ${RPM_BUILD_ROOT}

%post
#if [ "$1" == "1"]; then
#  %{_bindir}/entermediadb setup
#elif [ "$1" == "2" ]; then
#  %{_bindir}/entermediadb upgrade
#fi

%preun

%postun

%clean
rm -rf ${RPM_BUILD_ROOT}

%files
/home/entermedia/.ffmpeg
%{_bindir}/entermediadb
%{_bindir}/qt-faststart
/usr/share/entermediadb

%changelog
* Fri Jun 05 2015 Adam Bellows <adam@entermediasoftware.com> 1.0-2
- Change to entermediadb future parameterized script, no post-install
* Wed Jun 03 2015 Adam Bellows <adam@entermediasoftware.com> 1.0-1
- Update files list. Pre/post upgrade directives
* Tue Feb 24 2015 Chris Rose <chris.rose@entermediasoftware.com> 1.0-0
- Initial Build