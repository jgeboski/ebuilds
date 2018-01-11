# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit unpacker

DESCRIPTION="A beautiful cross platform Desktop Player for Google Play Music"
HOMEPAGE="https://www.googleplaymusicdesktopplayer.com"
SRC_URI_AMD64="https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${PV}/google-play-music-desktop-player_${PV}_amd64.deb"
SRC_URI_X86="https://github.com/MarshallOfSound/Google-Play-Music-Desktop-Player-UNOFFICIAL-/releases/download/v${PV}/google-play-music-desktop-player_${PV}_i386.deb"
SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
	x86? ( ${SRC_URI_X86} )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND="
	app-crypt/p11-kit
	dev-libs/atk
	dev-libs/dbus-glib
	dev-libs/expat
	dev-libs/glib
	dev-libs/gmp
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	dev-libs/libpcre
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/nettle
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libpng
	media-libs/mesa
	net-libs/gnutls
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/pixman"

RESTRICT="binchecks mirror"
S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local MY_PN=${PN%-bin}
	local MY_EXE=/opt/${MY_PN}/"Google Play Music Desktop Player"

	insinto /opt
	doins -r usr/share/${MY_PN}
	fperms 0755 "${MY_EXE}"
	dosym "${MY_EXE}" /usr/bin/${MY_PN}
	dodoc -r usr/share/doc/${MY_PN}

	insinto /usr/share/applications
	doins usr/share/applications/*

	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/*
}
