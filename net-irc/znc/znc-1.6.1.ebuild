# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{3_2,3_3,3_4} )
inherit base python-single-r1 user

DESCRIPTION="An advanced IRC Bouncer"
HOMEPAGE="http://wiki.znc.in/ZNC"
SRC_URI="http://znc.in/releases/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~*"
IUSE="daemon debug icu ipv6 perl python sasl ssl tcl zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	icu? ( dev-libs/icu )
	perl? ( >=dev-lang/perl-5.10 )
	python? ( ${PYTHON_DEPS} )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( dev-libs/openssl )
	tcl? ( dev-lang/tcl )
	zlib? ( sys-libs/zlib )"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	perl? ( >=dev-lang/swig-3 )
	python? ( >=dev-lang/swig-3 )"

CONFDIR="/var/lib/znc"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi

	if use daemon; then
		enewgroup "${PN}"
		enewuser  "${PN}" -1 -1 /dev/null ${PN}
	fi
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable icu charset) \
		$(use_enable ipv6) \
		$(use_enable perl) \
		$(use_enable python python python3) \
		$(use_enable sasl cyrus) \
		$(use_enable ssl openssl) \
		$(use_enable tcl) \
		$(use_enable zlib)
}

src_install() {
	if use daemon; then
		newinitd "${FILESDIR}/znc.initd" znc
		newconfd "${FILESDIR}/znc.confd" znc
	fi

	base_src_install
}

pkg_config() {
	"${EROOT}/usr/bin/znc" znc -crd "${EROOT}${CONFDIR}"
	chown -R "${PN}" "${EROOT}${CONFDIR}"
}
