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

src_prepare() {
	MAINDIR="Boje-Greyscale"

	for dir in $(find -path './*' -maxdepth 1 -type d ! -iname ${MAINDIR}); do
		for file in $(find "${dir}" -type f); do
			link="${MAINDIR}/$(echo "${file}" | cut -d/ -f3-)"

			[ -e "${link}" ] || continue

			fsum=$(md5sum "${file}" | awk '{print $1}')
			lsum=$(md5sum "${link}" | awk '{print $1}')

			[ "${fsum}" == "${lsum}" ] || continue

			for i in $(echo "${file}" | grep -o / | tail -n +2); do
				link="../${link}"
			done

			rm -f "${file}"
			ln -sf "${link}" "${file}"
		done
	done
}

src_install() {
	insinto /usr/share/themes
	doins -r Boje-*

	insinto /usr/share/emerald/themes
	doins -r emerald/Boje
}
