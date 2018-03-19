# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils git-r3

DESCRIPTION="Discord protocol plugin for BitlBee"
HOMEPAGE="https://github.com/sm00th/bitlbee-discord"
EGIT_REPO_URI="https://github.com/sm00th/bitlbee-discord.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=net-im/bitlbee-3.5[plugins]
	>=dev-libs/glib-2.32.0"
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
