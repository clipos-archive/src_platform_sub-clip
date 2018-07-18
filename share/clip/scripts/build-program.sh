#!/bin/bash
# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2017-2018 ANSSI. All Rights Reserved.

set -e
set -u

if [ x"$1" == x"-s" ]; then
    PRE_CMD="echo Would compile with: "
    PREFIX_CMD="echo"
    EXECCMD="/bin/bash"
    shift
else
    PRE_CMD=""
    PREFIX_CMD=""
    EXECCMD=""
fi


SPECIES=$1
PROGRAM=$2
DATE=$(date "+%Y-%m-%d-%H:%M")
LOGDIR="/log"


# creates category directory
mkdir -p $LOGDIR/${PROGRAM%/*}

# copy existing configuration
cp -a /config/* /etc

for var in CLIP_BUILDER CLIP_MAKEOPTS CLIP_ARCH CLIP_CHOST; do
	echo "${var}=\"${!var}\"" >> /etc/clip-build.conf
done

# clip-build would fail with the following error
# clip-build: Exception in main block: Cannot move /etc/portage: Invalid cross-device link; at /usr/bin/clip-build line 687.
cp -ra /etc/portage{,.bak}
rm -fr /etc/portage
mv /etc/portage{.bak,}

# it is important here to change reported architecture to i686

$PRE_CMD

$PREFIX_CMD linux32 clip-compile $SPECIES --depends -pkgn $PROGRAM 2> >(tee -a $LOGDIR/$PROGRAM-$DATE.err) > >(tee -a $LOGDIR/$PROGRAM-$DATE.log >&2)
$PREFIX_CMD linux32 clip-compile $SPECIES -pkgn $PROGRAM 2> >(tee -a $LOGDIR/$PROGRAM-$DATE.err) > >(tee -a $LOGDIR/$PROGRAM-$DATE.log >&2)
rv=$?

if [ -n "$EXECCMD" ]; then
    exec $EXECCMD
fi

exit $rv
