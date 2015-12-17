# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit webapp

MY_PV="${PV}-beta"

DESCRIPTION="Lightweight, customizable, and self-hosted RSS feed aggregator"
HOMEPAGE="http://freshrss.org"
SRC_URI="https://github.com/FreshRSS/FreshRSS/archive/${MY_PV}.tar.gz -> ${MY_PV}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~*"
IUSE="mysql +sqlite test"

RDEPEND="
	>=dev-lang/php-5.2.1[mysql?,sqlite?,ctype,curl,gmp,intl,json,xml,zip]
	virtual/httpd-php"

DEPEND="
	test? ( dev-php/phpunit )"

need_httpd_cgi
S="${WORKDIR}/FreshRSS-${MY_PV}"

# Testing is severely broken, seemingly unfinished, and seems to get
# little attention by upstream.
#
#src_test() {
#	( cd tests && phpunit . ) || die "Testing failed"
#}

src_install() {
	webapp_src_preinst
	dodoc CHANGELOG.md CONTRIBUTING.md CREDITS.md LICENSE README.md

	insinto "/${MY_HTDOCSDIR}"
	doins -r app data extensions lib p
	doins constants.php index.html index.php

	webapp_serverowned -R "${MY_HTDOCSDIR}/data"
	webapp_src_install
}
