# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils git-2

DESCRIPTION="Steam protocol plugin for BitlBee"
HOMEPAGE="https://github.com/jgeboski/bitlbee-steam"
EGIT_REPO_URI="https://github.com/jgeboski/bitlbee-steam.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	>=net-im/bitlbee-3.2.2[plugins]
	>=dev-libs/glib-2.32.0
	>=dev-libs/libgcrypt-1.5.0"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-minimal-flags
}

src_install() {
	default
	prune_libtool_files
}
