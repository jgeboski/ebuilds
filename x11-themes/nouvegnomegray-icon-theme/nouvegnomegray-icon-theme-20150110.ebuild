# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MY_PV="d4ytv8m"

inherit gnome2-utils unpacker

DESCRIPTION="Light gray icon set for GNOME"
HOMEPAGE="http://tsujan.deviantart.com/art/nouveGnomeGray-300365158"
SRC_URI="nouvegnomegray_by_tsujan-${MY_PV}.7z"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RESTRICT="binchecks fetch strip"
S="${WORKDIR}/nouveGnomeGray"

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_install() {
	insinto /usr/share/icons/nouveGnomeGray
	doins -r Extra scalable index.theme

	for size in {16,22,24,32,48,128,256}; do
		doins -r "${size}x${size}"
	done

	dodoc AUTHORS README
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
