# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils gnome2-utils multilib waf-utils

DESCRIPTION="Plugin for Thunar that adds context-menu items from dropbox"
HOMEPAGE="http://softwarebakery.com/maato/thunar-dropbox.html"
SRC_URI="http://www.softwarebakery.com/maato/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND="
	>=xfce-base/thunar-1.1
	dev-libs/glib:2
	net-misc/dropbox"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user

	sed \
		-e "s;gtk-update-icon-cache;true;" \
		-e "s;/lib/;/$(get_libdir)/;" \
		-i wscript
}

src_install() {
	waf-utils_src_install
	dodoc AUTHORS ChangeLog
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
