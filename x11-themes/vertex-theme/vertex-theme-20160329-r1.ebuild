# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils

DESCRIPTION="An elegant GTK2, GTK3, and GNOME theme"
HOMEPAGE="https://github.com/horst3180/vertex-theme"
SRC_URI="https://github.com/horst3180/vertex-theme/archive/${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ayatana dark gnome gtk2 gtk3 light xfwm"

RDEPEND="
	x11-themes/gnome-themes-standard
	gtk2? ( x11-themes/gtk-engines-murrine )
	gtk3? ( x11-libs/gtk+:3= )"

DEPEND="virtual/pkgconfig"
RESTRICT="binchecks strip"

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ayatana unity) \
		$(use_enable dark) \
		$(use_enable gnome gnome-shell) \
		$(use_enable gnome metacity) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable light) \
		$(use_enable xfwm) \
		--disable-cinnamon
}
