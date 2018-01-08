# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils git-r3

DESCRIPTION="Steam protocol plugin for BitlBee"
HOMEPAGE="https://github.com/bitlbee/bitlbee-steam"
EGIT_REPO_URI="https://github.com/bitlbee/bitlbee-steam.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=net-im/bitlbee-3.4[plugins]
	>=dev-libs/glib-2.32.0
	>=dev-libs/libgcrypt-1.5.0:0="
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user
	eautoreconf
}

src_install() {
	default
	prune_libtool_files
}
