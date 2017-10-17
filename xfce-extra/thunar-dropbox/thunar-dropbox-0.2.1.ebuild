# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit eutils gnome2-utils multilib python-single-r1 waf-utils

DESCRIPTION="Plugin for Thunar that adds context-menu items from dropbox"
HOMEPAGE="http://softwarebakery.com/maato/thunar-dropbox.html"
SRC_URI="http://www.softwarebakery.com/maato/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
