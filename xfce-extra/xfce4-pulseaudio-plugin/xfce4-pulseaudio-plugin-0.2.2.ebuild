# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit xfconf

DESCRIPTION="A panel plugin for Xfce for controlling an audiooutput volume of the PulseAudio mixer"
HOMEPAGE="http://goodies.xfce.org/projects/panel-plugins/xfce4-pulseaudio-plugin"
SRC_URI="http://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="debug +keybinder"

RDEPEND="
	>=dev-libs/glib-2.24
	>=media-sound/pulseaudio-0.9.19
	>=x11-libs/gtk+-3.6:3
	>=xfce-base/exo-0.6
	>=xfce-base/libxfce4ui-4.11
	>=xfce-base/libxfce4util-4.9
	>=xfce-base/xfce4-panel-4.11
	>=xfce-base/xfconf-4.6
	keybinder? ( dev-libs/keybinder:3 )"

DEPEND="
	${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		# Disable IDO support for now
		--disable-ido

		$(use_enable keybinder)
		$(xfconf_use_debug)
	)

	DOCS=( AUTHORS ChangeLog NEWS README THANKS )
}
