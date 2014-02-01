# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Personal package builder for Debian packages"
HOMEPAGE="http://packages.qa.debian.org/p/pbuilder.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/p/pbuilder/pbuilder_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="uml"

DEPEND="
	>=sys-apps/debianutils-1.13.1
	app-arch/dpkg
	dev-util/debootstrap
	net-misc/wget
	sys-apps/fakeroot
	uml? (
		>=dev-util/rootstrap-0.3.9
		sys-apps/usermode-utilities
	)"

pkg_pretend() {
	if use uml && ! use amd64 && ! use x86; then
		die "User Mode Linux is not supported with this architecture"
	fi
}

src_prepare() {
	# Temporary hack to disable documentation
	sed -i "/Documentation/d" Makefile
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README THANKS
	doman debuild-pbuilder.1 pbuilder.8 pbuilderrc.5 pdebuild.1

	rm -rf ${D}/var

	if use uml; then
		doman \
			pbuilder-uml.conf.5 \
			pbuilder-user-mode-linux.1 \
			pdebuild-user-mode-linux.1
	else
		rm -f \
			${D}/etc/pbuilder/pbuilder-uml.conf \
			${D}/usr/bin/pbuilder-user-mode-linux \
			${D}/usr/bin/pdebuild-user-mode-linux \
			${D}/usr/share/pbuilder/pbuilder-uml.conf \
			${D}/usr/lib/pbuilder/pbuilder-uml-checkparams \
			${D}/usr/lib/pbuilder/pdebuild-uml-checkparams
	fi
}
