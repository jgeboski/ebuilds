# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="Tools used by jgeboski for system maintenance"
HOMEPAGE="https://github.com/jgeboski/ebuilds"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="grub"

RDEPEND="
	sys-apps/portage
	grub? ( sys-boot/grub:2[-multislot] )"
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	:;
}

src_install() {
	insinto /usr/share/jgetools
	doins "${FILESDIR}"/lib/*

	for bin in "${FILESDIR}"/bin/*; do
		name=$(basename "${bin}" | sed 's/^jge//')

		if ! in_iuse ${name} || use ${name}; then
			dobin "${bin}"
		fi
	done
}
