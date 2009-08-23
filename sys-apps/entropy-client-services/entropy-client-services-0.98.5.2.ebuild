# Copyright 2004-2007 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
inherit eutils python

DESCRIPTION="Official Sabayon Linux Package Manager library"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="http://distfiles.sabayonlinux.org/${CATEGORY}/entropy-${PV}.tar.bz2"
RESTRICT="mirror"
S="${WORKDIR}/entropy-${PV}"

DEPEND="dev-python/dbus-python
        >=sys-apps/dbus-1.2.6
	dev-python/pygobject
	~sys-apps/entropy-${PV}
"
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1 || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/$(get_libdir)" updates-daemon-install || die "make install failed"
}

pkg_postinst() {
	python_mod_compile "/usr/$(get_libdir)/entropy/services"
}

pkg_postrm() {
        python_mod_cleanup "/usr/$(get_libdir)/entropy/services"
}

