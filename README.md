# Tardiff
Makes tar archives out of diffs in a git archive. Groups archives by their top level
directory in the git archive.

### Usage
```bash
.
├── makefile
├── README.md
├── src
│   ├── example.h
│   └── example.cpp
├── lib
│   └── example.a
└── doc
    └── example.pdf
```
If the files `example.cpp`, `example.h`, and `example.pdf` were changed, then running
```bash
$ tardiff
```
from within the git archive would generate tar archives named `src-YYYYMMDD.tar.gz` and
`doc-YYYYMMDD.tar.gz`

To naively remove any generated tar archives, run
```bash
$ tardiff -c
$ tardiff --clean
```

### Install
Choose either the bash or python implementation using `-b` and `-p` respectively. Run
```bash
$ ./install.sh -b
```
Which will prompt you for a path and then create `tardiff` there using the selected
implementation.
