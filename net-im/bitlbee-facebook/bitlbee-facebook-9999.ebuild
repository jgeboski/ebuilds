# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils git-2

DESCRIPTION="Facebook protocol plugin for BitlBee"
HOMEPAGE="https://github.com/jgeboski/bitlbee-facebook"
EGIT_REPO_URI="https://github.com/jgeboski/bitlbee-facebook.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=net-im/bitlbee-3.4[plugins]
	>=dev-libs/glib-2.32.0
	>=dev-libs/json-glib-0.14
	sys-libs/zlib"
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
