#!/bin/sh

ARCH=$(uname -m)
if [ "$ARCH" == "armv7l" ]
then
    ARCH='armv7'
fi

/opt/notify_push/bin/${ARCH}/notify_push /etc/nc_config.php
