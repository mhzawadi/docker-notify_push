#!/bin/sh

ARCH=$(uname -m)

/opt/notify_push/bin/${ARCH}/notify_push /etc/nc_config.php
