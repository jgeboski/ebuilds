# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils user

DESCRIPTION="Tools used by jgeboski for system maintenance"
HOMEPAGE="https://github.com/jgeboski/ebuilds"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="grub"

RDEPEND="
	dev-lang/perl
	sys-apps/portage
	grub? ( sys-boot/grub:2[-multislot] )"
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	:;
}

src_install() {
	local bin

	insinto /usr/share/jgetools
	doins "${FILESDIR}"/lib/*

	for bin in "${FILESDIR}"/bin/*; do
		name=$(basename "${bin}" | sed 's/^jge//')

		if ! in_iuse ${name} || use ${name}; then
			dosbin "${bin}"
		fi
	done
}
