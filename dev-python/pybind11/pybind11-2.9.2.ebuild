# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake distutils-r1

DESCRIPTION="AST-based Python refactoring library"
HOMEPAGE="https://pybind11.readthedocs.io/en/stable/"
SRC_URI="https://github.com/pybind/pybind11/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~x86"

RDEPEND="
	dev-cpp/eigen:3
"
BDEPEND="
	test? (
		>=dev-cpp/catch-2.13.5
		>=dev-libs/boost-1.56
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	export PYBIND11_USE_CMAKE=1
	cmake_src_prepare
	distutils-r1_python_prepare_all
}

python_configure() {
	local mycmakeargs=(
		# disable forced lto
		-DPYBIND11_LTO_CXX_FLAGS=
		-DPYBIND11_INSTALL=ON
		-DPYBIND11_TEST=$(usex test)
	)
	cmake_src_configure
}

python_compile() {
	distutils-r1_python_compile
	# Compilation only does anything for tests
	use test && cmake_src_compile
}

python_test() {
	cmake_build check
}

python_install() {
	distutils-r1_python_install
	cmake_src_install
}
