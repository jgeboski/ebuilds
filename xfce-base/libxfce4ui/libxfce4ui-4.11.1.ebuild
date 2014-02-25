# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit xfconf

DESCRIPTION="Unified widgets and session management libraries for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/libxfce4"
SRC_URI="http://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug glade gtk3 startup-notification"

RDEPEND="
	!xfce-base/xfce-utils
	>=dev-libs/glib-2.28
	>=x11-libs/gtk+-2.24:2
	>=xfce-base/libxfce4util-4.10
	>=xfce-base/xfconf-4.10
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	glade? ( >=dev-util/glade-3.5:3 )
	gtk3? ( >=x11-libs/gtk+-3.2:3 )
	startup-notification? ( x11-libs/startup-notification )"

DEPEND="
	${RDEPEND}
	dev-lang/perl
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

	XFCONF=(
		$(use_enable glade gladeui)
		$(use_enable gtk3)
		$(use_enable startup-notification)
		$(xfconf_use_debug)
		--with-vendor-info=Gentoo
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
	)

	[[ ${CHOST} == *-darwin* ]] && XFCONF+=( --disable-visibility ) #366857
}
