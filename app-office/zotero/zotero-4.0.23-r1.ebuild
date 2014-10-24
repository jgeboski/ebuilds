# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
OFFICE_EXTENSIONS=( Zotero_OpenOffice_Integration.oxt )

inherit eutils gnome2-utils office-ext-r1

DESCRIPTION="Zotero is a free tool to help you manage your research sources"
HOMEPAGE="https://www.zotero.org/"
SRC_URI="https://download.zotero.org/standalone/${PV}/Zotero-${PV}_linux-i686.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	sys-apps/which
	|| (
		<www-client/firefox-34.0
		<www-client/firefox-bin-34.0
		<www-client/seamonkey-2.31
		<www-client/seamonkey-bin-2.31
	)"

DOCS=( README.md )

A="Zotero-${PV}_linux-i686.tar.bz2"
S="${WORKDIR}/Zotero_linux-i686"
OFFICE_EXTENSIONS_LOCATION="${S}/extensions/zoteroOpenOfficeIntegration@zotero.org/install"

src_unpack() {
	office-ext-r1_src_unpack
	cd "${S}"
}

src_prepare() {
	epatch_user
	cp "${FILESDIR}/zotero" .
	sed -i "s;@appini@;/usr/share/${PN}/application.ini;" zotero
}

src_install() {
	office-ext-r1_src_install
	dobin zotero

	insinto /usr/share/${PN}
	doins -r chrome components defaults icons
	doins application.ini chrome.manifest updater.ini zotero.jar

	insinto /usr/share/applications
	doins "${FILESDIR}/zotero.desktop"

	for size in 16 32 48; do
		dosym \
			/usr/share/${PN}/chrome/icons/default/default${size}.png \
			/usr/share/icons/hicolor/${size}x${size}/apps/zotero.png
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	office-ext-r1_pkg_postinst
	gnome2_icon_cache_update
}

pkg_prerm() {
	office-ext-r1_pkg_prerm
}

pkg_postrm() {
	gnome2_icon_cache_update
}
