# Copyright 2004-2009 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
inherit eutils python multilib

DESCRIPTION="Official Sabayon Linux Entropy Notification Applet (KDE/Qt version)"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="http://distfiles.sabayonlinux.org/sys-apps/entropy-${PV}.tar.bz2"
RESTRICT="mirror"
S="${WORKDIR}/entropy-${PV}/magneto"

DEPEND="~app-misc/magneto-loader-${PV}
	kde-base/pykde4
"
RDEPEND="${DEPEND}"

src_compile() {
	einfo "nothing to compile"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/$(get_libdir)" magneto-kde-install || die "make install failed"
}

pkg_postinst() {
	python_mod_optimize "/usr/$(get_libdir)/entropy/magneto/magneto/kde"
}

pkg_postrm() {
        python_mod_cleanup "/usr/$(get_libdir)/entropy/magneto/magneto/kde"
}

