#!/bin/python3

import argparse
import os
import sys
import tarfile
import shutil
import glob
from datetime import date
from collections import defaultdict
from git import Repo

def cleanTarballs ():
    tarArchives = glob.glob (os.getcwd () + "/*.tar.gz")
    for archive in tarArchives:
        os.remove (archive)

def makeTarballs ():
    # move to the .git directory
    startingDir = os.getcwd ()
    while os.path.exists (".git") is not True:
        os.chdir ("..")

    # verify the repo exists
    repo = Repo (os.getcwd ())
    assert not repo.bare

    # map all diffs based on their top level directory
    tarballs = defaultdict (list)
    gitDiffs = [ diff.a_path for diff in repo.index.diff (None) ]
    for diff in gitDiffs:
        topLevelDir = diff.split ("/")[0]
        tarballs[topLevelDir].append (diff)

    # make a tar archive of changed files, use top level directory as name
    for tarball in tarballs:
        tarballDir = tarball + "-" + date.today ().strftime ("%Y%m%d") + ".tar.gz"
        with tarfile.open (tarballDir, "w:gz") as tar:
            for gitDiff in tarballs[tarball]:
                tar.add (gitDiff)


        if os.getcwd () != startingDir:
            shutil.move (tarballDir, startingDir + "/" + tarballDir)



if __name__ == "__main__":
    parser = argparse.ArgumentParser (description="collects diffs in a git archive by "\
                                      "top level directory and creates tar archives "\
                                      "with them")
    parser.add_argument ("-c", "--clean", action="store_true",
                         help="remove generated tar archives")

    args = parser.parse_args ()
    if args.clean:
        cleanTarballs ()

    else:
        makeTarballs ()

    sys.exit (0)
