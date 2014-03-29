# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils unpacker

DESCRIPTION="Minimalistic icon theme set"
HOMEPAGE="http://tsujan.deviantart.com/art/nouveGnomeGray-300365158"
SRC_URI="https://dl.dropboxusercontent.com/u/4069017/downloads/awoken-2.5.zip"

LICENSE="CC-BY-SA-3.0 CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="app-arch/unzip"
RESTRICT="binchecks strip"

src_unpack() {
	unpack "${A}"

	mv "$(ls -1 | head -1)" "${P}"
	cd "${P}"

	unpacker *.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-syntax-errors.patch"
	epatch "${FILESDIR}/${P}-customizer-variables.patch"

	MAINDIR="AwOken"

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

src_compile() {
	for norm in $(find -type d -name 'AwOken*' | cut -d/ -f2-); do
		mono="${norm}Mono"

		cp -a "${norm}" "${mono}"
		sed -i "s/\(Name\)=.*/\1=${mono}/" "${mono}/index.theme"

		ICONSET="${norm}" \
		HOMEDIR="${S}" \
		bash AwOken/extra/customize.sh -S gentoo3 "${S}/${norm}"

		ICONSET="${mono}" \
		HOMEDIR="${S}" \
		bash AwOken/extra/customize.sh -c no-color -S gentoo3 "${S}/${mono}"
	done

	ICONSET="AwOkenMono" \
	HOMEDIR="${S}" \
	bash AwOken/extra/customize.sh -F awoken -f awokenclear "${S}/AwOkenMono"
}

src_install() {
	insinto /usr/share/icons
	doins -r AwOken AwOkenDark AwOkenWhite
	doins -r AwOkenMono AwOkenDarkMono AwOkenWhiteMono

	dodoc AwOken/Installation_and_Instructions.pdf

	find "${D}" \
		\( \
			-name "*-customization*" -o \
			-name "*.pdf" -o \
			-name "*.sh" -o \
			-name ".AwOkenrc*" \
		\) -exec rm -rf '{}' \;

	MAINICON="nvidia-settings.png"
	LINKICON="nvidia-drivers-settings.png"

	for icon in $(find \( -type f -o -type l \) -name ${MAINICON}); do
		idir=$(dirname $(echo ${icon} | cut -d/ -f2-))
		dosym ${MAINICON} /usr/share/icons/${idir}/${LINKICON}
	done
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
