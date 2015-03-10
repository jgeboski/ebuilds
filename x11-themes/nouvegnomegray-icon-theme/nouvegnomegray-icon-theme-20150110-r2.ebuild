# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MY_PV="d4ytv8m"

inherit gnome2-utils unpacker

DESCRIPTION="Light gray icon set for GNOME"
HOMEPAGE="http://tsujan.deviantart.com/art/nouveGnomeGray-300365158"
SRC_URI="http://fc01.deviantart.net/fs71/f/2015/010/9/b/nouvegnomegray_by_tsujan-${MY_PV}.7z"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND="
	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic"

RESTRICT="binchecks strip"
S="${WORKDIR}/nouveGnomeGray"

MY_SIZES=("scalable")

for size in {16,22,24,32,48,128,256}; do
	MY_SIZES+=("${size}x${size}")
done

src_prepare() {
	LINKS=(
		"apps/gvim->vim"
		"apps/nvidia-drivers-settings->nvidia-settings"
		"apps/qtconfig->qtconfig-qt4"
		"apps/speedcrunch->accessories-calculator"
	)

	for size in ${MY_SIZES[@]}; do
		ext=$([ "${size}" == "scalable" ] && echo svg || echo png)

		for link in ${LINKS[@]}; do
			link=(${link/->/ })
			file="${size}/$(dirname ${link[0]})/${link[1]}.${ext}"

			if [ -e "${file}" ]; then
				ln -sf "${link[1]}.${ext}" "${size}/${link[0]}.${ext}"
			fi
		done
	done
}

src_install() {
	insinto /usr/share/icons/nouveGnomeGray
	doins -r ${MY_SIZES[@]} Extra index.theme

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
