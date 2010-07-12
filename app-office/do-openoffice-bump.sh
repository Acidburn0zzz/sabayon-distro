#!/bin/sh

FROM_PV="3.2.0"
TO_PV="3.2.1"
FAILED_LANGS=""
DONE_LANGS=""
for item in `find -name openoffice-l10n-*${FROM_PV}*.ebuild`; do

	echo $item
	newfile=${item/${FROM_PV}/${TO_PV}}
	cp ${item} ${newfile}

	# do manifest
	ebuild "${newfile}" manifest
	if [ "$?" != "0" ]; then
		FAILED_LANGS="${FAILED_LANGS} ${newfile}"
		rm "${newfile}"
	else
		DONE_LANGS="${DONE_LANGS} ${newfile}"
		git add "${newfile}"
	fi

done

echo "FAILED => ${FAILED_LANGS}"
echo "DONE => ${DONE_LANGS}"
