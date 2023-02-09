#!/bin/bash

usage ()
{
  cat <<EOF
usage: ${0} [-h] {-b, -g, -p}

installs the specified version of tardiff to the given path

options:
  -h, --help    show this help message and exit
  -b, --bash    installs the bash version of tardiff
  -g, --go      installs the go version of tardiff
  -p, --python  installs the python version of tardiff
EOF
}

installTarget ()
{
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
  cp "src/tardiff${extension}" "${installDir}/tardiff"
  if [[ $? -eq 0 ]]; then
    echo "Copied 'tardiff${extension}' to ${installDir}/tardiff"
    exit 0
  else
    echo "Failed to copy 'tardiff${extension}' to ${installDir}/tardiff"
    exit 1
  fi
}

if [[ $# -eq 0 || $# -gt 1 ]]; then
  usage
  exit 1
else
  case "${1}" in
    -h|--help)
      usage
      exit 1
      ;;
    -b|--bash)
      extension=".sh"
      installTarget
      ;;
    -g|--go)
      extension=".go"
      installTarget
      ;;
    -p|--python)
      extension=".py"
      installTarget
      ;;
    *)
      echo "Unknown option ${1}"
      usage
      exit 1
      ;;
  esac
fi

