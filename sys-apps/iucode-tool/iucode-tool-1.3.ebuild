# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools linux-info vcs-snapshot

DESCRIPTION="Intel 64 and IA-32 processor microcode tool"
HOMEPAGE="https://gitlab.com/iucode-tool/iucode-tool"
SRC_URI="${HOMEPAGE}/repository/archive.tar.gz?ref=v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="debug? ( dev-util/valgrind )"
DEPEND="${RDEPEND}"

pkg_pretend() {
	CONFIG_CHECK="~MICROCODE"
	check_extra_config
}

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug valgrind-build)
}
