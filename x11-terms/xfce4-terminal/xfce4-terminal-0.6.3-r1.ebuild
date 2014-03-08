# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit xfconf

DESCRIPTION="A terminal emulator for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/terminal/"
SRC_URI="http://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug"

RDEPEND="
	>=dev-libs/glib-2.26
	>=x11-libs/gtk+-2.24:2
	>=x11-libs/vte-0.28:0
	>=xfce-base/libxfce4ui-4.10
	x11-libs/libX11"

DEPEND="
	${RDEPEND}
	dev-util/intltool
	dev-libs/libxml2
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog HACKING NEWS README THANKS )

	# Disable the server until multi-display issues are resolved
	# https://bugzilla.xfce.org/show_bug.cgi?id=10109
	PATCHES=( "${FILESDIR}"/${P}-disable-server.patch )

	XFCONF=(
		$(xfconf_use_debug)
	)
}