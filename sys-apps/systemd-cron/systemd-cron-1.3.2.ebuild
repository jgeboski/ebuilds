# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{3_1,3_2,3_3,3_4} )

inherit eutils multilib python-single-r1 python-utils-r1

DESCRIPTION="systemd units providing cron directory functionality"
HOMEPAGE="https://github.com/systemd-cron/systemd-cron"
SRC_URI="https://github.com/systemd-cron/systemd-cron/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sys-apps/systemd-212
	sys-apps/debianutils
	sys-process/cronbase"

src_prepare() {
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
		--statedir=/var/spool/cron/crontabs \
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
}
