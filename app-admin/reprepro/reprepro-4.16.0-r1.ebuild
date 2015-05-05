# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit flag-o-matic

DESCRIPTION="Tool to handle local repositories of debian packages."
HOMEPAGE="https://mirrorer.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/file/4109/reprepro_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive bzip2 gpgme lzma"

RDEPEND="
	sys-libs/db
	sys-libs/zlib
	archive? ( app-arch/libarchive )
	bzip2? ( app-arch/bzip2 )
	gpgme? (
		app-crypt/gpgme
		dev-libs/libgpg-error
	)
	lzma? ( app-arch/lzma )"

DEPEND="${RDEPEND}"

src_configure() {
	use gpgme && append-cflags -I/usr/include/gpgme

	econf \
		$(use_with archive libarchive) \
		$(use_with bzip2   libbz2) \
		$(use_with gpgme   libgpgme) \
		$(use_with lzma    liblzma)
}
