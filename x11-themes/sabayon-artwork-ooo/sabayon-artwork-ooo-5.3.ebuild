# Copyright 1999-2009 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2
EAPI="2"
inherit eutils multilib

DESCRIPTION="Sabayon OpenOffice Artwork"
HOMEPAGE="http://www.sabayonlinux.org/"
SRC_URI="http://distfiles.sabayonlinux.org/${CATEGORY}/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="nomirror"
# Temporary to ease transition
DEPEND=">=app-office/openoffice-3.1.1-r2"

S="${WORKDIR}/${PN}"

src_install () {
	cd ${S}
	insinto /usr/$(get_libdir)/openoffice/program
	doins *.bmp
}

pkg_postinst () {
	ewarn "Please report bugs or glitches to"
	ewarn "bugs.sabayonlinux.org"
}
