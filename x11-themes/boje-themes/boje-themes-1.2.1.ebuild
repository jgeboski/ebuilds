# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker

DESCRIPTION="Slick and simple dark GTK2/3 theme"
HOMEPAGE="http://nale12.deviantart.com/art/Boje-1-2-1-342853818"
SRC_URI="https://dl.dropboxusercontent.com/u/4069017/downloads/boje-themes-1.2.1.zip"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="
	x11-themes/gtk-engines
	x11-themes/gtk-engines-murrine"

DEPEND="
	${RDEPEND}
	app-arch/unzip"

RESTRICT="binchecks strip"
S="${WORKDIR}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	mv Boje.emerald Boje.tar.gz
	mkdir -p emerald/Boje

	( cd emerald/Boje; unpacker "${S}/Boje.tar.gz" )
}

src_install() {
	insinto /usr/share/themes
	doins -r Boje-*

	insinto /usr/share/emerald/themes
	doins -r emerald/Boje
}
