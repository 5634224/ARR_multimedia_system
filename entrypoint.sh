#!/bin/bash
ip route replace default via 192.168.255.2
exec $ENTRYPOINT
