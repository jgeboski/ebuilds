# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit gnome2-utils unpacker

DESCRIPTION="Light gray icon set for GNOME"
HOMEPAGE="http://tsujan.deviantart.com/art/nouveGnomeGray-300365158"
SRC_URI="https://orig00.deviantart.net/e36f/f/2017/277/e/c/nouvegnomegray_by_tsujan-d4ytv8m.7z"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
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
	while read line; do
		local link=(${line/->/ })

		if [ "${#link[@]}" != "2" ]; then
			continue
		fi

		local path=($(echo "${link[@]}" | xargs -n1 dirname))
		local name=($(echo "${link[@]}" | xargs -n1 basename))
		local dirc=${path[$?]}

		for size in ${MY_SIZES[@]}; do
			local file=$(find "${size}/${dirc}" -name "${name[1]}.*" | head -1)
			local dirp=$([ "${path[1]}" == "." ] || echo "../")
			local ext=${file##*.}

			if [ -n "${file}" ]; then
				ln -sf "${dirp}${link[1]}.${ext}" "${size}/${link[0]}.${ext}"
			fi
		done
	done < "${FILESDIR}/additional-symlinks-${PV}"
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
