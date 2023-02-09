#!/bin/bash

usage ()
{
  cat <<EOF
usage: ${0} [-h] [-c]

collects diffs in a git archive by top level directory and creates tar archives with them

options:
  -h, --help   show this help message and exit
  -c, --clean  remove generated tar archives
EOF
}

cleanTarballs ()
{
  rm -f *.tar.gz
}

makeTarballs ()
{
  # move to the .git directory
  startingDir="${PWD}"
  while [ ! -d ".git" ]; do
    cd ..
  done

  # map all diffs based on their top level directory
  declare -A tarballs
  readarray -t gitDiffs < <(git diff --name-only)
  for diff in "${gitDiffs[@]}"; do
    topLevelDir=$(echo "${diff}" | cut -d "/" -f 1)
    tarballs["${topLevelDir}"]="${tarballs[${topLevelDir}]} ${diff}"
  done

  # make a tar archive of changed files, use top level directory as name
  for tarball in "${!tarballs[@]}"; do
    tarballDir="${tarball}-$(date +%Y%m%d).tar.gz"
    tar czf "${tarballDir}" $(echo "${tarballs[${tarball}]}" | tr -d "'")

    # move tarball to the current directory
    if [ "${PWD}" != "${startingDir}" ]; then
      mv "${tarballDir}" "${startingDir}/${tarballDir}"
    fi
  done
}

if [[ $# -eq 0 ]]; then
  makeTarballs
else
  while [[ $# -gt 0 ]]; do
    case "${1}" in
      -c|--clean)
        cleanTarballs
        exit 0
        ;;
      -h|--help)
        usage
        exit 1
        ;;
      *)
        echo "Unknown option ${1}"
        usage
        exit 1
        ;;
    esac
  done
fi
