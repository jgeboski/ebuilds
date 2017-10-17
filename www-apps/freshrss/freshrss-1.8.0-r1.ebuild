# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit webapp

DESCRIPTION="Lightweight, customizable, and self-hosted RSS feed aggregator"
HOMEPAGE="http://freshrss.org"
SRC_URI="https://github.com/FreshRSS/FreshRSS/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="mysql postgres +sqlite"

RDEPEND="
	>=dev-lang/php-5.3.3[mysql?,postgres?,sqlite?,ctype,curl,gmp,intl,json,xml,zip]
	virtual/httpd-php
	mysql? ( >=virtual/mysql-5.5.3 )
	postgres? ( >=dev-db/postgresql-9.2 )"

#DEPEND="test? ( dev-php/phpunit )"

need_httpd_cgi
S="${WORKDIR}/FreshRSS-${PV}"

# Testing is severely broken, seemingly unfinished, and seems to get
# little attention by upstream.
#
#src_test() {
#	( cd tests && phpunit . ) || die "Testing failed"
#}

src_install() {
	webapp_src_preinst
	dodoc CHANGELOG.md CONTRIBUTING.md CREDITS.md README.md README.fr.md

	insinto "/${MY_HTDOCSDIR}"
	doins -r app data extensions lib p
	doins config-user.default.php config.default.php constants.php
	doins force-https.default.txt index.html index.php

	webapp_serverowned -R "${MY_HTDOCSDIR}/data"
	webapp_src_install
}
