# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit xfconf

DESCRIPTION="Panel for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/"
SRC_URI="http://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug gtk3"

RDEPEND="
	>=dev-libs/dbus-glib-0.73
	>=dev-libs/glib-2.24
	>=x11-libs/cairo-1
	>=x11-libs/gtk+-2.20:2
	>=x11-libs/libwnck-2.30:1
	>=xfce-base/exo-0.7.2
	>=xfce-base/garcon-0.1.5
	>=xfce-base/libxfce4ui-4.11
	>=xfce-base/libxfce4util-4.9
	>=xfce-base/xfconf-4.9
	x11-libs/libX11
	gtk3? ( >=x11-libs/gtk+-3.2:3 )"

DEPEND="
	${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS THANKS )

	XFCONF=(
		$(use_enable gtk3)
		$(xfconf_use_debug)
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
	)
}
