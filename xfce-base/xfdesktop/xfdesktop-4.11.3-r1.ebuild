# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit xfconf

DESCRIPTION="Desktop manager for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/"
SRC_URI="http://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug libnotify thunar"

RDEPEND="
	>=dev-libs/glib-2.30
	>=x11-libs/gtk+-2.24:2
	>=x11-libs/libwnck-2.30:1
	>=xfce-base/exo-0.7
	>=xfce-base/garcon-0.1.2
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfconf-4.10
	x11-libs/libSM
	x11-libs/libX11
	libnotify? ( >=x11-libs/libnotify-0.4 )
	thunar? (
		>=xfce-base/thunar-1.2[dbus]
		>=dev-libs/dbus-glib-0.84
	)"

DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README TODO )

	PATCHES=(
		"${FILESDIR}/${P}-fix-segfault-on-start.patch"
		"${FILESDIR}/${P}-reload-iconview.patch"
		"${FILESDIR}/${P}-fix-crash-display-removal.patch"
	)

	XFCONF=(
		$(use_enable libnotify notifications)
		$(use_enable thunar file-icons)
		$(use_enable thunar thunarx)
		$(xfconf_use_debug)
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
	)
}
