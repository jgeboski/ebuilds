# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit vim-plugin

if [[ "${PV}" != 9999* ]]; then
	SRC_URI="https://github.com/mhinz/vim-signify/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/vim-${P}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mhinz/vim-signify.git"
fi

DESCRIPTION="vim plugin: indicate changed lines within a file using a VCS"
HOMEPAGE="https://github.com/mhinz/vim-signify"
LICENSE="MIT"
VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm -rf LICENSE pictures showcolors.bash
}
