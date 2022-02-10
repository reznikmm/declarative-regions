# SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
#
# SPDX-License-Identifier: MIT
#

%undefine _hardened_build
%define _gprdir %_GNAT_project_dir
%define rtl_version 0.1

Name:       declarative_regions
Version:    0.1.0
Release:    git%{?dist}
Summary:    Grammar handling and parser generation Ada library
Group:      Development/Libraries
License:    MIT
URL:        https://github.com/reznikmm/declarative-regions
### Direct download is not availeble
Source0:    declarative-regions.tar.gz
BuildRequires:   gcc-gnat
BuildRequires:   fedora-gnat-project-common  >= 3 
# BuildRequires:   matreshka-devel
BuildRequires:   gprbuild

# gprbuild only available on these:
ExclusiveArch: %GPRbuild_arches

%description
The declarative-regions is a library for ...

%package devel

Group:      Development/Libraries
License:    MIT
Summary:    Devel package for the declarative_regions
Requires:       %{name}%{?_isa} = %{version}-%{release}
Requires:   fedora-gnat-project-common  >= 2

%description devel
Devel package for declarative_regions

%package run
Summary:    Run executable for declarative_regions
License:    MIT
Group:      System Environment/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description run
This an executable for the declarative_regions

%prep 
%setup -q -n %{name}

%build
make  %{?_smp_mflags} GPRBUILD_FLAGS="%Gnatmake_optflags"

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot} LIBDIR=%{_libdir} PREFIX=%{_prefix} GPRDIR=%{_gprdir} BINDIR=%{_bindir}

%check
make  %{?_smp_mflags} GPRBUILD_FLAGS="%Gnatmake_optflags" check

%post     -p /sbin/ldconfig
%postun   -p /sbin/ldconfig

%files
%doc LICENSES/*
%dir %{_libdir}/%{name}
%{_libdir}/%{name}/libdeclarative_regions.so.%{rtl_version}
%{_libdir}/libdeclarative_regions.so.%{rtl_version}
%{_libdir}/%{name}/libdeclarative_regions.so.0
%{_libdir}/libdeclarative_regions.so.0
%files devel
%doc README.md
%{_libdir}/%{name}/libdeclarative_regions.so
%{_libdir}/libdeclarative_regions.so
%{_libdir}/%{name}/*.ali
%{_includedir}/%{name}
%{_gprdir}/declarative_regions.gpr
%{_gprdir}/manifests/declarative_regions

%files run
%{_bindir}/declarative_regions-run
%{_gprdir}/manifests/declarative_regions_run

%changelog
* Sun Feb 28 2021 Maxim Reznik <reznikmm@gmail.com> - 0.1.0-git
- Initial package
