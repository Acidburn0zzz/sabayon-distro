# Copyright 2004-2009 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
inherit eutils multilib python bash-completion

DESCRIPTION="Official Sabayon Linux Package Manager Client"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="http://distfiles.sabayonlinux.org/sys-apps/entropy-${PV}.tar.bz2"
RESTRICT="mirror"
S="${WORKDIR}/entropy-${PV}"

DEPEND="~sys-apps/entropy-${PV}"
RDEPEND="${DEPEND} sys-apps/file[python]"

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/$(get_libdir)" equo-install || die "make install failed"
	dobashcompletion "${S}/misc/equo-completion.bash" equo
}

pkg_postinst() {
	python_mod_optimize "/usr/$(get_libdir)/entropy/client"
	bash-completion_pkg_postinst
}

pkg_postrm() {
        python_mod_cleanup "/usr/$(get_libdir)/entropy/client"
}

