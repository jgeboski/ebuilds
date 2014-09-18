# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Official Python API client for Discogs"
HOMEPAGE="http://github.com/discogs/discogs_client http://pypi.python.org/pypi/discogs-client"
SRC_URI="http://github.com/discogs/discogs_client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

DOCS=( README.mkd )
S="${WORKDIR}"/${P/-/_}

python_test() {
	distutils_install_for_testing
	"${PYTHON}" discogs_client/tests/__init__.py  || die "Testing failed"
}
