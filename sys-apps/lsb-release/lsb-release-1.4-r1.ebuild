# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="LSB version query program"
HOMEPAGE="http://www.linuxbase.org/"
SRC_URI="mirror://sourceforge/lsb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

# Perl isn't needed at runtime, it is just used to generate the man page.
DEPEND="dev-lang/perl"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.4-fix-find-infos.patch"
	epatch_user
}

src_install() {
	emake install \
		prefix="${D}/usr" \
		mandir="${D}/usr/share/man"

	mkdir -p "${D}/etc"
	echo 'DISTRIB_ID="Gentoo"' > ${D}/etc/lsb-release
}
