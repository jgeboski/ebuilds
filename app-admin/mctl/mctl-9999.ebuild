# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 distutils-r1 git-2

DESCRIPTION="Minecraft server controller"
HOMEPAGE="https://github.com/jgeboski/mctl"
EGIT_REPO_URI="https://github.com/jgeboski/mctl.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND=""
DEPEND=""

DOCS=( config.json README )

python_install_all() {
	distutils-r1_python_install_all
	doman man/${PN}{,-fake}.1
	dobashcomp scripts/completion/${PN}{,-fake}
}
