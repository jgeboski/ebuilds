# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib

DESCRIPTION="systemd units providing cron directory functionality"
HOMEPAGE="https://github.com/dbent/systemd-cron"
SRC_URI="https://github.com/dbent/systemd-cron/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sys-apps/systemd-197
	sys-apps/debianutils
	sys-process/cronbase"

src_configure() {
	./configure \
		--prefix=/usr \
		--confdir=/etc \
		--datadir=/usr/share \
		--docdir=/usr/share/doc/${PF} \
		--libdir=/usr/$(get_libdir) \
		--runparts=/bin/run-parts \
		--enable-daily \
		--enable-hourly \
		--enable-monthly \
		--enable-weekly
}

pkg_postinst() {
	elog "For ${PN} to work, it must be enabled/started:"
	elog "  # systemctl enable cron.target"
	elog "  # systemctl start cron.target"
}
