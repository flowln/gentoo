# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing a full text editor component"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+editorconfig"

RESTRICT="test"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kauth-${PVCUT}*:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
	=kde-frameworks/kcompletion-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kguiaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kitemviews-${PVCUT}*:5
	=kde-frameworks/kjobwidgets-${PVCUT}*:5
	=kde-frameworks/kparts-${PVCUT}*:5
	=kde-frameworks/ktextwidgets-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kxmlgui-${PVCUT}*:5
	=kde-frameworks/sonnet-${PVCUT}*:5
	=kde-frameworks/syntax-highlighting-${PVCUT}*:5
	editorconfig? ( app-text/editorconfig-core-c )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( >=kde-frameworks/kservice-${PVCUT}:5 )"

PATCHES=(
	"${FILESDIR}/${P}-fix-crash-w-stale-indexes.patch" # KDE-bug 451593
	"${FILESDIR}/${P}-fix-toggle-comment.patch" # KDE-bug 451471
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package editorconfig EditorConfig)
	)

	ecm_src_configure
}
