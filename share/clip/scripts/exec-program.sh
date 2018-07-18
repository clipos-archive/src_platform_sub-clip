#!/bin/bash
# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2017-2018 ANSSI. All Rights Reserved.

set -e
set -u

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

linux32 $*
