# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Normaliz is a tool for computations in affine monoids and more"
HOMEPAGE="http://www.mathematik.uni-osnabrueck.de/normaliz/"
SRC_URI="http://www.mathematik.uni-osnabrueck.de/normaliz/Normaliz2.2Linux32.zip"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="dev-libs/gmp[-nocxx]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Normaliz2.2Linux/source"

src_prepare () {
	sed -i "s/-O3/${CXXFLAGS}/" Makefile || die "sed on Makefile failed"
}

src_install() {
	dobin norm32 norm64 normbig || die "install failed"
	if use doc; then
		dodoc "../doc/Normaliz2.2Documentation.pdf" || die "install failed"
	fi
}
