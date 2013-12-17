# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools flag-o-matic

DESCRIPTION="Emerald window decorator"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://git.compiz.org/fusion/decorators/${PN}/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="~amd64 ~x86"
IUSE="+themes"

PDEPEND="themes? ( x11-themes/emerald-themes )"

RDEPEND="
	>=x11-libs/gtk+-2.8.0:2
	>=x11-libs/libwnck-2.19.4:1
	x11-wm/compiz:0.9"

DEPEND="
	${RDEPEND}
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.15
	virtual/pkgconfig"

src_prepare() {
	append-libs -ldl -lm
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-fast-install
}

src_install() {
	default
	prune_libtool_files

	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
