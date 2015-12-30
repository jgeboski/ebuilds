# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MY_HOME="/etc/ssl/lecerts"

inherit eutils user

DESCRIPTION="Tools used by jgeboski for system maintenance"
HOMEPAGE="https://github.com/jgeboski/ebuilds"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="grub lecerts"

RDEPEND="
	sys-apps/portage
	grub? ( sys-boot/grub:2[-multislot] )
	lecerts? ( app-crypt/simp_le )"
DEPEND=""

S="${WORKDIR}"

pkg_setup() {
	if use lecerts; then
		enewgroup lecerts
		enewuser lecerts -1 /bin/bash -1 lecerts
	fi
}

src_unpack() {
	:;
}

src_install() {
	insinto /usr/share/jgetools
	doins "${FILESDIR}"/lib/*

	for bin in "${FILESDIR}"/bin/*; do
		name=$(basename "${bin}" | sed 's/^jge//')

		if ! in_iuse ${name} || use ${name}; then
			dosbin "${bin}"
		fi
	done

	if use lecerts; then
		keepdir "${MY_HOME}"
	fi
}
