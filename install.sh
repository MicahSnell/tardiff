#!/usr/bin/env bash

INSTALL_DIR=$(echo $PATH | cut -d ":" -f 1)
cp -p src/tardiff $INSTALL_DIR
echo "Copied 'tardiff' to $INSTALL_DIR"
