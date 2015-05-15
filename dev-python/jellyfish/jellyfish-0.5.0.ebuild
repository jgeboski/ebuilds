# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python library for doing approximate and phonetic matching of strings"
HOMEPAGE="https://github.com/sunlightlabs/jellyfish"
SRC_URI="http://github.com/sunlightlabs/jellyfish/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="~*"
IUSE="doc"

RDEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.rst )

python_prepare_all() {
	distutils-r1_python_prepare_all
	use doc && emake -C docs text
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dodoc docs/_build/text/*.txt
}
