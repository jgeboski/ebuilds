# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils git-2 udev

DESCRIPTION="Library for interfacing with Logitech G710+ keyboards"
HOMEPAGE="https://github.com/jgeboski/libg710p"
EGIT_REPO_URI="https://github.com/jgeboski/libg710p.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="tools pulseaudio"

REQUIRED_USE="pulseaudio? ( tools )"

RDEPEND="
	pulseaudio? (
		|| (
			sys-libs/glibc
			sys-libs/argp-standalone
		)
		media-sound/pulseaudio
	)"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable pulseaudio pulseaudio-tool ) \
		$(use_enable tools) \
		--with-udev-dir="$(get_udevdir)"
}

src_install() {
	default
	prune_libtool_files
}
