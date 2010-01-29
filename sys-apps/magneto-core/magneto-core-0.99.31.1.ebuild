# Copyright 2004-2009 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
inherit eutils python

DESCRIPTION="Official Sabayon Linux Entropy Notification Applet Core library"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="http://distfiles.sabayonlinux.org/sys-apps/entropy-${PV}.tar.bz2"
RESTRICT="mirror"
S="${WORKDIR}/entropy-${PV}"

DEPEND="
	~sys-apps/entropy-client-services-${PV}
        x11-misc/xdg-utils"
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1 || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/$(get_libdir)" magneto-core-install || die "make install failed"
}

pkg_postinst() {
	python_mod_compile "/usr/$(get_libdir)/entropy/magneto"
}

pkg_postrm() {
        python_mod_cleanup "/usr/$(get_libdir)/entropy/magneto"
}

