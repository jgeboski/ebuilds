# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.6"

inherit gnome2-utils multilib python waf-utils

DESCRIPTION="Plugin for Thunar that adds context-menu items from dropbox"
HOMEPAGE="http://softwarebakery.com/maato/thunar-dropbox.html"
SRC_URI="http://www.softwarebakery.com/maato/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=xfce-base/thunar-1.2
	dev-libs/glib:2
	net-misc/dropbox"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
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
