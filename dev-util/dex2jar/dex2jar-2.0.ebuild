# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
MY_ANTLR_SLOT="3"
MY_ASM_SLOT="4"

inherit java-pkg-2

DESCRIPTION="Tools to work with android .dex and java .class files"
HOMEPAGE="https://github.com/pxb1988/dex2jar"
SRC_URI="https://bitbucket.org/pxb1988/dex2jar/downloads/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.7
	dev-java/antlr:${MY_ANTLR_SLOT}
	dev-java/asm:${MY_ASM_SLOT}"
DEPEND=""

src_prepare() {
	rm -f d2j_invoke.sh lib/antlr*.jar lib/asm*.jar
}

src_install() {
	local bin
	local lib

	java-pkg_register-dependency antlr-${MY_ANTLR_SLOT}
	java-pkg_register-dependency asm-${MY_ASM_SLOT}
	java-pkg_jarinto /opt/${PN}

	for lib in lib/*.jar; do
		local name=$(basename "${lib}" .jar | rev | cut -d- -f2- | rev)
		java-pkg_newjar "${lib}" "${name}.jar"
	done

	for bin in *.sh; do
		local name=$(basename "${bin}" .sh)
		local main=$(grep -h /d2j_invoke "${bin}" | awk '{print $2}' | tr -d \")
		java-pkg_dolauncher "${name}" --main "${main}"
	done
}
