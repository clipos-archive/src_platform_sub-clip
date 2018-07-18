#!/bin/bash
# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2017-2018 ANSSI. All Rights Reserved.

set -e


# copy existing configuration
cp -a /config/* /etc

for var in CLIP_BUILDER; do
	echo "${var}=\"${!var}\"" >> /etc/clip-build.conf
done

# it is important here to change reported architecture to i686
linux32 -- clip-sign $@  /pkg.deb 
