# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit xfconf

DESCRIPTION="Window manager for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/"
SRC_URI="http://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug startup-notification +xcomposite"

RDEPEND="
	>=dev-libs/dbus-glib-0.72
	>=x11-libs/gtk+-2.24:2
	>=x11-libs/libwnck-2.22:1
	>=xfce-base/libxfce4ui-4.11
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/xfconf-4.8
	sys-apps/dbus
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
	startup-notification? ( x11-libs/startup-notification )
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXfixes
	)"

DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog COMPOSITOR NEWS README TODO )

	XFCONF=(
		$(use_enable startup-notification)
		$(use_enable xcomposite compositor)
		$(xfconf_use_debug)
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--enable-randr
		--enable-render
		--enable-xsync
	)
}
