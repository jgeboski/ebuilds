# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils fdo-mime gnome2-utils unpacker

DESCRIPTION="Computational software based on symbolic mathematics"
HOMEPAGE="http://www.wolfram.com/mathematica"
SRC_URI="Mathematica_${PV}_LINUX.sh"

LICENSE="Wolfram-Mathematica"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc selinux"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="bindist fetch mirror"
QA_PREBUILT="*"

PKGARCH=$(use amd64 && echo x86_64 || echo x86)
S=${WORKDIR}/

pkg_pretend() {
	use x86 || use amd64 || die "Unsupported system architecture"
}

pkg_nofetch() {
	elog "Please download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_unpack() {
	offset=$(grep -anm 1 '^offset=`head' ${DISTDIR}/${A} | awk '{print $3}')
	cd "${S}"

	if [ -n "$offset" ]; then
		offset=$(head -n ${offset} ${DISTDIR}/${A} | wc -c)
		unpack_makeself ${A} ${offset} dd
	else
		unpack_makeself
	fi

	if use doc; then
		packages="
			MasterLayout.Paclet.English
			Notebooks.Online.English
			Usage.Online.English"

		for package in ${packages}; do
			unpacker "${S}"/Unix/Files/${package}/contents.tar.gz
		done
	fi

	unpacker $(find "${S}/Unix/Files" \
		-path "${S}/Unix/Files/*" -maxdepth 1 -type d \
		\( \
			! -name "*.Linux$(use amd64 || echo -x86_64)" -a \
			! -name "Fonts.*" -a \
			! -name "Indexer.Online.English" -a \
			! -name "MasterLayout.Paclet.English" -a \
			! -name "Notebooks.Online.English" -a \
			! -name "Usage.Online.English" \
		\) \
		-printf "%p/contents.tar.gz\n")
}

src_prepare() {
	fields="
		CreationID
		MinorReleaseNumber
		ReleaseNumber
		VersionNumber"

	for field in ${fields}; do
		read ${field} <<< $(\
			find Unix -name info -exec cat {} \; | \
			grep ^${field} | awk '{print $2}' | sort | uniq)
	done

	FullVersionNumber="${VersionNumber}.${ReleaseNumber}.${MinorReleaseNumber}"

	echo "${CreationID}"        > .CreationID
	echo "${FullVersionNumber}" > .VersionID

	echo "FullVersionNumber: ${FullVersionNumber}" >> .Revision
	echo "CreationID: ${CreationID}"               >> .Revision
}

src_install() {
	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop

	doman SystemFiles/SystemDocumentation/Unix/*.1
	rm -rf SystemFiles/SystemDocumentation

	insinto /usr/share/mime/application
	doins SystemFiles/Installation/*.xml
	rm -rf SystemFiles/Installation/

	insinto /opt/${PN}
	doins .CreationID .Revision .VersionID

	find . -path "./*" -maxdepth 1 -type d \
		\( \
			! -name Files -a \
			! -name Installer -a \
			! -name Unix \
		\) \
		-exec mv {} ${D}/opt/${PN} \;

	for size in 32 64 128; do
		xresdir=/opt/${PN}/SystemFiles/FrontEnd/SystemResources/X
		hicrdir=/usr/share/icons/hicolor/${size}x${size}

		dosym \
			${xresdir}/Mathematica-${size}.png \
			${hicrdir}/apps/mathematica.png
	done

	for executable in $(ls -1 ${D}/opt/${PN}/Executables); do
		dosym /opt/${PN}/Executables/${executable} /opt/bin/${executable}
	done

	dosym /opt/${PN}/Executables/Mathematica /opt/bin/mathematica

	use doc     || find ${D} -depth -name Documentation -exec rm -rf {} \;
	use selinux && find ${D} -name "*.so*" -exec chcon -t textrel_shlib_t {} \;
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	gnome2_icon_cache_update
	gnome2_schemas_update
}
