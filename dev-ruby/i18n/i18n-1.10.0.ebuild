# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="test"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Add Internationalization support to your Ruby application"
HOMEPAGE="http://rails-i18n.org/"
SRC_URI="https://github.com/svenfuchs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "dev-ruby/concurrent-ruby:1"

ruby_add_bdepend "test? (
	>=dev-ruby/activesupport-5.1
	dev-ruby/bundler
	>=dev-ruby/mocha-1.7.0
	dev-ruby/test_declarative )"

all_ruby_prepare() {
	rm -f gemfiles/*.lock || die

	# Remove optional unpackaged oj gem
	sed -i -e '/oj/ s:^:#:' gemfiles/* || die

	# Update old test dependencies
	sed -i -e '/rake/ s/~>/>=/' -e 's/1.7.0/1.7/' -e '3igem "json"' gemfiles/* || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby30)
			versions="7.0"
			;;
		*ruby27)
			versions="6.0 6.1 7.0"
			;;
		*ruby26)
			versions="5.2 6.0 6.1"
			;;
	esac

	for version in ${versions} ; do
		if has_version "dev-ruby/activesupport:${version}" ; then
			einfo "Running tests with activesupport ${version}"
			BUNDLE_GEMFILE="${S}/gemfiles/Gemfile.rails-${version}.x" ${RUBY} -S bundle exec ${RUBY} -S rake test || die
		fi
	done
}
