# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit linux-info

DESCRIPTION="Transparent and scalable SSL/TLS interception"
HOMEPAGE="http://www.roe.ch/SSLsplit"
SRC_URI="https://github.com/droe/sslsplit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT APSL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="
	>=dev-libs/libevent-2.0
	dev-libs/openssl:="

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )"

pkg_pretend() {
	CONFIG_CHECK="
		~IP_NF_TARGET_REDIRECT
		~NETFILTER_XT_TARGET_REDIRECT
		~NETFILTER_XT_TARGET_TPROXY"

	check_extra_config
}

src_compile() {
	unset FEATURES
	emake
}

src_test() {
	unset FEATURES
	emake -j1 test
}

src_install() {
	unset FEATURES
	emake install PREFIX="/usr" DESTDIR="${D}"
}
