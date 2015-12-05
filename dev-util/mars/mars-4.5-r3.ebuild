# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MY_PV="${PV/./_}"
MY_DATE="MARS_${MY_PV}_Aug2014"

inherit eutils gnome2-utils java-pkg-2

DESCRIPTION="Interactive IDE for programming in MIPS assembly language"
HOMEPAGE="http://courses.missouristate.edu/KenVollmar/MARS/index.htm"
SRC_URI="http://courses.missouristate.edu/KenVollmar/mars/${MY_DATE}/Mars${MY_PV}.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	:;
}

src_install() {
	java-pkg_jarinto /opt/${PN}
	java-pkg_newjar "${DISTDIR}/Mars${MY_PV}.jar" ${PN}.jar
	java-pkg_dolauncher

	insinto /usr/share/icons/hicolor/64x64/apps
	doins "${FILESDIR}/mars.png"
	make_desktop_entry ${PN} MARS "" "" "MimeType=text/x-asm;"
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
