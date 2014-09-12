# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils multilib python-single-r1 python-utils-r1

DESCRIPTION="systemd units providing cron directory functionality"
HOMEPAGE="https://github.com/dbent/systemd-cron"
SRC_URI="https://github.com/dbent/systemd-cron/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-process/cronbase:="
RDEPEND="
	${DEPEND}
	>=sys-apps/systemd-212
	sys-apps/debianutils"

# The crontab directory
CRONTAB_DIR="/var/spool/cron/crontabs"

src_prepare() {
	epatch "${FILESDIR}/${P}-path-fixes.patch"
	epatch_user

	python_fix_shebang src/bin
}

src_configure() {
	./configure \
		--prefix=/usr \
		--confdir=/etc \
		--docdir=/usr/share/doc/${PF} \
		--libdir=/usr/$(get_libdir) \
		--runparts=/bin/run-parts \
		--statedir=/var \
		--enable-boot=yes \
		--enable-daily=yes \
		--enable-hourly=yes \
		--enable-monthly=yes \
		--enable-persistent=yes \
		--enable-weekly=yes \
		--enable-yearly=yes
}

pkg_postinst() {
	elog "For ${PN} to work, it must be enabled/started:"
	elog "  # systemctl enable cron.target"
	elog "  # systemctl start cron.target"

	# Make the CRONTAB_DIR group writable
	chmod g+w "${CRONTAB_DIR}"
}

pkg_postrm() {
	# Remove the CRONTAB_DIR group writable
	chmod g-w "${CRONTAB_DIR}"
}
