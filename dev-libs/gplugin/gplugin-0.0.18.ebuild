# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{3_2,3_3,3_4} )
HGV="9f4dea11d6eb"

inherit cmake-utils python-single-r1

DESCRIPTION="GObject based library that implements a reusable plugin system"
HOMEPAGE="https://bitbucket.org/rw_grim/gplugin"
SRC_URI="https://bitbucket.org/rw_grim/${PN}/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="gtk introspection lua nls perl python test"

REQUIRED_USE="
	lua? ( introspection )
	perl? ( introspection )
	python? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.20
	gtk? ( x11-libs/gtk+:3 )
	introspection? ( dev-libs/gobject-introspection )
	lua? (
		|| (
			>=dev-lang/lua-5.1
			>=dev-lang/luajit-2
		)
		dev-lua/lgi
	)
	nls? ( sys-devel/gettext )
	perl? ( dev-lang/perl )
	python? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )"

DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/rw_grim-${PN}-${HGV}"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-lua-check.patch"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build gtk GTK3)
		$(cmake-utils_use_build introspection GIR)
		$(cmake-utils_use_build lua LUA)
		$(cmake-utils_use_build python PYTHON)
		$(cmake-utils_use nls NLS)
		$(cmake-utils_use test TESTING_ENABLED)
		-DBUILD_GJS=NO  # Build failures
		-DBUILD_SEED=NO # Missing dependency
	)

	cmake-utils_src_configure
}
