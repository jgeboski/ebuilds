# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit xfconf

DESCRIPTION="Configuration system for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/"
SRC_URI="http://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug libcanberra libnotify upower +xklavier"

RDEPEND="
	>=dev-libs/dbus-glib-0.84
	>=dev-libs/glib-2.24
	>=x11-libs/gtk+-2.20:2
	>=x11-libs/libXcursor-1.1
	>=x11-libs/libXi-1.3
	>=x11-libs/libXrandr-1.2
	>=xfce-base/garcon-0.1.10
	>=xfce-base/exo-0.7.1
	>=xfce-base/libxfce4ui-4.11
	>=xfce-base/libxfce4util-4.9
	>=xfce-base/xfconf-4.9
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXrandr
	libcanberra? ( >=media-libs/libcanberra-0.25[sound] )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	upower? ( sys-power/upower )
	xklavier? ( >=x11-libs/libxklavier-5 )"

DEPEND="
	${RDEPEND}
	>=x11-proto/inputproto-1.4
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS TODO )

	XFCONF=(
		$(use_enable libcanberra sound-settings)
		$(use_enable libnotify)
		$(use_enable upower)
		$(use_enable xklavier libxklavier)
		$(xfconf_use_debug)
		--enable-randr
	)
}
