#!/bin/bash

# get install path
defaultInstallDir="${HOME}/.local/bin"
read -p "Enter install path or press enter to install at '${defaultInstallDir}': " \
     installDir
installDir="${installDir:-${defaultInstallDir}}"

# verify directory exists
if [ ! -d "${installDir}" ]; then
  echo "Failed to install"
  echo "Directory ${installDir} does not exist"
  exit 1
fi

# copy to installDir
cp src/tardiff "${installDir}"
if [ "$?" -eq 0 ]; then
  echo "Copied 'tardiff' to ${installDir}"
  exit 0
else
  echo "Failed to copy 'tardiff' to ${installDir}"
  exit 1
fi

