# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit java-pkg-2 java-ant-2 git-2

DESCRIPTION="Analytical decompiler for Java"
HOMEPAGE="https://github.com/JetBrains/intellij-community"
EGIT_REPO_URI="https://github.com/JetBrains/intellij-community.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~*"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

MY_S="plugins/java-decompiler/engine"
EANT_BUILD_XML="${MY_S}/build.xml"
EANT_BUILD_TARGET="dist"

src_install() {
	java-pkg_dojar "${MY_S}/fernflower.jar"
	java-pkg_dolauncher
	dodoc ${MY_S}/readme.txt
}
