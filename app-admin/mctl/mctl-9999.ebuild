# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit bash-completion-r1 distutils git-2 python

DESCRIPTION="Minecraft server controller"
HOMEPAGE="https://github.com/jgeboski/mctl"
EGIT_REPO_URI="https://github.com/jgeboski/mctl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/setuptools"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install

	dodoc config.json README
	doman man/${PN}{,-fake}.1

	dobashcomp scripts/completion/${PN}{,-fake}
}

pkg_postinst() {
	distutils_pkg_postinst
}
