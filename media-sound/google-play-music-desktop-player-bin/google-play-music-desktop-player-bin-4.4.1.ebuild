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
