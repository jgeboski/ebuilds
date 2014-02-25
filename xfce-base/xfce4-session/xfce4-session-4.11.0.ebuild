# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit xfconf

DESCRIPTION="A session manager for the Xfce desktop environment"
HOMEPAGE="http://docs.xfce.org/xfce/xfce4-session/start"
SRC_URI="http://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="consolekit debug policykit systemd udev +xscreensaver"

COMMON_DEPEND="
	!xfce-base/xfce-utils
	>=dev-libs/dbus-glib-0.84
	>=sys-apps/dbus-1.1
	>=x11-libs/gtk+-2.20:2
	>=x11-libs/libwnck-2.30:1
	>=xfce-base/libxfce4ui-4.9
	>=xfce-base/libxfce4util-4.9
	>=xfce-base/xfconf-4.9
	x11-apps/iceauth
	x11-libs/libSM
	x11-libs/libX11"

RDEPEND="
	${COMMON_DEPEND}
	x11-apps/xrdb
	x11-misc/xdg-user-dirs
	consolekit? ( sys-auth/consolekit )
	policykit? ( >=sys-auth/polkit-0.104-r1 )
	udev? ( >=sys-power/upower-0.9.15 )
	xscreensaver? ( || (
		>=x11-misc/xlockmore-5.38
		>=x11-misc/slock-1
		>=x11-misc/xscreensaver-5.15
		gnome-extra/gnome-screensaver
	) )
	systemd? ( >=sys-auth/polkit-0.100 )"

DEPEND="
	${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS BUGS ChangeLog NEWS README TODO )

	XFCONF=(
		$(use_enable systemd)
		$(xfconf_use_debug)
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--with-xsession-prefix="${EPREFIX}"/usr
	)
}

src_install() {
	xfconf_src_install

	local sessiondir=/etc/X11/Sessions
	echo startxfce4 > "${T}"/Xfce4

	exeinto ${sessiondir}
	doexe "${T}"/Xfce4
	dosym Xfce4 ${sessiondir}/Xfce
}
