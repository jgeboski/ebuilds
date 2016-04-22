# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit git-2 python-single-r1 python-utils-r1

DESCRIPTION="Tool to synchronize files between a PC and an Android device using ADB"
HOMEPAGE="https://github.com/google/adb-sync"
EGIT_REPO_URI="https://github.com/google/adb-sync.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~*"
IUSE="+channel"

RDEPEND="
	dev-util/android-tools
	channel? ( net-misc/socat )"
DEPEND=""

src_install() {
	dodoc README.md
	python_doscript adb-sync
	use channel && dobin adb-channel
}
