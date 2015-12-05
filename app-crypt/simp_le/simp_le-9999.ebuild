# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1 git-2

DESCRIPTION="Simple Let's Encrypt client"
HOMEPAGE="https://github.com/kuba/simp_le"
EGIT_REPO_URI="https://github.com/kuba/simp_le.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE="test"

RDEPEND="
	>=app-crypt/acme-0.1.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pep8[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
	)"

DOCS=( CONTRIBUTING.md README.md )

python_prepare_all() {
	# Allow other versions of app-crypt/acme
	sed -ri 's/(acme)==[0-9\.]+/\1/g' setup.py
}
