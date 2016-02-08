# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 python-r1 user

DESCRIPTION="Music streaming server based on CherryPy and jPlayer"
HOMEPAGE="http://www.fomori.org/cherrymusic"
SRC_URI="https://github.com/devsnd/cherrymusic/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE="+channel"

RDEPEND=">=dev-python/cherrypy-3.2.2[$PYTHON_USEDEP]"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "" ${PN}
}

python_prepare_all() {
	python_setup
	python_export EPYTHON

	XDG_CONFIG_HOME=portage \
	XDG_DATA_HOME=portage \
	"${EPYTHON}" ./cherrymusic --newconfig
	distutils-r1_python_prepare_all
}

python_install_all() {
	insinto /etc/${PN}
	newins portage/cherrymusic/cherrymusic.conf.new cherrymusic.conf
	newinitd "${FILESDIR}/cherrymusic.initd" ${PN}
	doman doc/man/*.{1,5,8}

	keepdir /var/lib/${PN}
	fperms 0700 /var/lib/${PN}
	fowners ${PN}:${PN} /var/lib/${PN}
	dosym /etc/${PN}/cherrymusic.conf /var/lib/${PN}/cherrymusic.conf
	distutils-r1_python_install_all
}
