# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Tools used by jgeboski for system maintenance"
HOMEPAGE="https://github.com/jgeboski/ebuilds"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND="sys-apps/portage"
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	:;
}

src_install() {
	insinto /usr/share/jgetools
	doins "${FILESDIR}"/lib/*
	dobin "${FILESDIR}"/bin/*
}
