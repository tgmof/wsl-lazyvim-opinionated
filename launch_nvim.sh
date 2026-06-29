#!/bin/bash
LINUX_PATH=$(wslpath -u "$1")
exec /home/linuxbrew/.linuxbrew/bin/nvim "$LINUX_PATH"
