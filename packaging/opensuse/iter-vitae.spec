# iter-vitae
#
# SPDX-License-Identifier: MIT
# Copyright © Josep Bigorra <jjbigorra@gmail.com>
#
# spec file for package iter-vitae
#
# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

# Scheme sources plus a bash launcher: there is no compiled binary to
# debug, so the empty -debugsource package is skipped.
%global debug_package %{nil}

Name:           iter-vitae
Version:        1.0.4
Release:        0
Summary:        Resume and curriculum vitae generator written in Guile Scheme
License:        MIT
URL:            https://codeberg.org/jjba23/iter-vitae
Source0:        %{name}-%{version}.tar.gz
BuildRequires:  pkgconfig(guile-3.0)
BuildRequires:  guile-lib
BuildRequires:  veritas
Requires:       guile
Requires:       bash
Requires:       coreutils
Requires:       guile-lib

# NOTE: guile-lib is not packaged in openSUSE yet.  Build it first
# (from a devel project if needed) before this package.
# veritas is produced by the same packaging batch; build it first.

%description
Iter Vitae generates a resume or curriculum vitae from a CV described in
Guile Scheme. It follows a model-view-controller split, renders HTML with
themes and emits a printable document.

%prep
%autosetup -n %{name}-%{version}

# The launcher is a bash script; point it at the interpreter path
# openSUSE packages are expected to use instead of /usr/bin/env.
sed -i '1s|^#!%{_bindir}/env \(.*\)$|#!%{_bindir}/\1|' scripts/iter-vitae

%build
# Nothing to build: the program is Scheme sources plus a launcher, and
# the sources are byte-compiled during %install so that they land in
# the interpreter's compiled-module directory.

%install
# Both directories are asked of Guile's pkg-config file rather than
# assumed, so the modules land where this distribution's Guile looks
# for them.
SITE_DIR="%{buildroot}$(pkg-config --variable=sitedir guile-3.0)"
CCACHE_DIR="%{buildroot}$(pkg-config --variable=siteccachedir guile-3.0)"

mkdir -p "$SITE_DIR/iter-vitae" "$CCACHE_DIR/iter-vitae"
cp -r src/iter-vitae/. "$SITE_DIR/iter-vitae/"

# Byte-compile every module so that loading it does not compile it
# again on first use.
find "$SITE_DIR/iter-vitae" -name '*.scm' | while read -r scm_file; do
  rel_path="${scm_file#$SITE_DIR/}"
  go_file="$CCACHE_DIR/${rel_path%.scm}.go"
  mkdir -p "$(dirname "$go_file")"
  guild compile -L "$SITE_DIR" -o "$go_file" "$scm_file"
done

install -D -m 0755 scripts/iter-vitae %{buildroot}%{_bindir}/iter-vitae

# Upstream reads resources from the generic share/resources; several of
# these packages would clash there, so it moves under share/iter-vitae/.
sed -i 's|share/resources|share/iter-vitae/resources|g' %{buildroot}%{_bindir}/iter-vitae

install -d "%{buildroot}%{_datadir}/iter-vitae/resources"
cp -r resources/. "%{buildroot}%{_datadir}/iter-vitae/resources/"

%check
VERITAS_TEST_TYPE=unit VERITAS_RUN_BENCHMARKS=false guile --fresh-auto-compile -L ./src -L ./test -c '((@ (veritas runner) run-tests))'

%files
%license LICENSE
%doc README.org NEWS.org
%{_bindir}/iter-vitae
%dir %{_datadir}/guile
%dir %{_datadir}/guile/site
%dir %{_datadir}/guile/site/3.0
%{_datadir}/guile/site/3.0/iter-vitae
%dir %{_libdir}/guile
%dir %{_libdir}/guile/3.0
%dir %{_libdir}/guile/3.0/site-ccache
%{_libdir}/guile/3.0/site-ccache/iter-vitae
%dir %{_datadir}/iter-vitae
%{_datadir}/iter-vitae/resources

%changelog
