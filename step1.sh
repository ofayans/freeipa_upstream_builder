#!/bin/bash
# FreeIPA requires:
BUILD_DEPS=$(grep "^BuildRequires" freeipa.spec.in | awk '{ print $2 }' | grep -v "^/")
DEPS=$(grep "^Requires" freeipa.spec.in | awk '!/%/ { print $2 }' | grep -v "^/")
# Fedora min build env
# (https://fedoraproject.org/wiki/Packaging:Guidelines#Exceptions_2)
DEPS="$DEPS bash bzip2 coreutils cpio diffutils fedora-release"
DEPS="$DEPS findutils gawk gcc gcc-c++ grep gzip info make patch"
DEPS="$DEPS redhat-rpm-config rpm-build sed shadow-utils tar unzip"
DEPS="$DEPS util-linux which xz python-gssapi"
# install all the RPMs
dnf install -y rpm-build python-kdcproxy $BUILD_DEPS $DEPS --enablerepo updates-testing
dnf distro-sync --enablerepo updates-testing -y
