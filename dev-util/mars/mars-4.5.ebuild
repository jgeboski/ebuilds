# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MY_PV="${PV/./_}"
MY_DATE="MARS_${MY_PV}_Aug2014"

inherit gnome2-utils

DESCRIPTION="Interactive IDE for programming in MIPS assembly language"
HOMEPAGE="http://courses.missouristate.edu/KenVollmar/MARS/index.htm"
SRC_URI="http://courses.missouristate.edu/KenVollmar/mars/${MY_DATE}/Mars${MY_PV}.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND="virtual/jre"
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	:;
}

src_prepare() {
	cat <<-EOF > mars
	#!/bin/sh
	java -jar /opt/mars/mars.jar
	EOF
}

src_install() {
	insinto /opt/mars
	newins "${DISTDIR}/Mars${MY_PV}.jar" mars.jar
	dobin mars

	insinto /usr/share/applications
	doins "${FILESDIR}/mars.desktop"

	insinto /usr/share/icons/hicolor/64x64/apps
	doins "${FILESDIR}/mars.png"
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
