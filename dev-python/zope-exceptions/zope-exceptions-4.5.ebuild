# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="General purpose exceptions for Zope packages"
HOMEPAGE="
	https://pypi.org/project/zope.exceptions/
	https://github.com/zopefoundation/zope.exceptions/
"
SRC_URI="mirror://pypi/${PN::1}/${PN/-/.}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	# strip rdep specific to namespaces
	sed -i -e "/'setuptools'/d" setup.py || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	# this is needed to keep the tests working while
	# dev-python/namespace-zope is still installed
	cat > zope/__init__.py <<-EOF || die
		__path__ = __import__('pkgutil').extend_path(__path__, __name__)
	EOF
	eunittest
	rm zope/__init__.py || die
}
