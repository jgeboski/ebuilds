# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MY_PV="f1d40ed7b4f626c373c8c149eba511b1eab474e1"

inherit eutils

DESCRIPTION="An elegant GTK2, GTK3, and GNOME theme"
HOMEPAGE="https://github.com/horst3180/Vertex-theme"
SRC_URI="https://github.com/horst3180/Vertex-theme/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana gnome"

RDEPEND="x11-themes/gtk-engines-murrine"
DEPEND="${RDEPEND}"

RESTRICT="binchecks strip"
S="${WORKDIR}/Vertex-theme-${MY_PV}"

src_prepare() {
	# Prevent unnecessary zipping
	sed -i "/^zip/d" build.sh
}

src_compile() {
	sh build.sh

	use ayatana || rm -rf Gnome-3.16/*/unity
	use gnome   || rm -rf Gnome-3.16/*/metacity-1
}

src_install() {
	insinto /usr/share/themes
	doins -r Gnome-3.16/*

	use gnome && dodir -r Vertex-Gnome-Shell

	dodoc README README.md
}