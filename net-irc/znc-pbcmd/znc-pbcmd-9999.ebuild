# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit git-2 multilib

DESCRIPTION="ZNC module which plays back buffers on command"
HOMEPAGE="http://wiki.znc.in/PBCmd"
EGIT_REPO_URI="https://gist.github.com/1169540.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=net-irc/znc-1.5:="
DEPEND="${RDEPEND}"

src_compile() {
	znc-buildmod pbcmd.cpp
}

src_install() {
	exeinto /usr/$(get_libdir)/znc
	doexe pbcmd.so
}
