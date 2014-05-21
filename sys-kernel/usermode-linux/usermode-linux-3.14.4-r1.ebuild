# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit flag-o-matic multilib versionator

MAJOR=$(get_major_version)

DESCRIPTION="The User Mode Linux (UML) kernel"
HOMEPAGE="https://www.kernel.org"
SRC_URI="https://www.kernel.org/pub/linux/kernel/v${MAJOR}.x/linux-${PV}.tar.xz"

LICENSE="freedist GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="custom-cflags"

RESTRICT="strip"
QA_WX_LOAD="usr/bin/linux"
S="${WORKDIR}/linux-${PV}"

pkg_pretend() {
	use amd64 || die "Unsupported system architecture"
}

pkg_setup() {
	use custom-cflags || strip-flags
	export LDFLAGS="$(raw-ldflags)"
}

src_configure() {
	emake defconfig ARCH=um
}

src_compile() {
	emake linux modules ARCH=um
}

src_install() {
	emake modules_install ARCH=um INSTALL_MOD_PATH="build"
	rm -f build/lib/modules/${PV}/{build,source}

	dodoc .config CREDITS MAINTAINERS README REPORTING-BUGS
	dobin linux

	insinto /usr/$(get_libdir)/${PN}
	doins -r build/lib/modules
}
