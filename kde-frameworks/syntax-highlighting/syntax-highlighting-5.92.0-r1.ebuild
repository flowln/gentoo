# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Framework for syntax highlighting"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-fix-bash.patch.xz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="nls"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/perl
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"

PATCHES=( "${WORKDIR}/${P}-fix-bash.patch" ) # KDE-bugs 450478

src_install() {
	ecm_src_install
	dobin "${BUILD_DIR}"/bin/katehighlightingindexer
}
