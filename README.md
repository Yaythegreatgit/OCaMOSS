## OCaMoss User's Guide

Plagiarism detection software, inspired by MOSS and implemented in OCaml.
Runs using a command-line interface.

This is NOT an OCaml client for MOSS, this is a completely separate program. For more details about the system or how MOSS works in general, read the PDF report in this repository or [this blog post](https://yangdanny97.github.io/blog/2019/05/03/MOSS) I wrote.

Note: this was originally written as the final project for a course - it has since been updated by me, so some aspects of the PDF report may not be accurate. In particular, the latest version of OCaMOSS no longer uses a 2-3 tree.

<hr>

- To build - `make`
- To build & run the REPL - `make run`
- To build & run unit tests -`make test`

Required Dependencies:
- Yojson
- ANSITerminal
- OUnit (for unit tests)

<hr>

### Commands: 
(note - commands are case-sensitive)

- `run [threshold]` - runs OCaMoss on the working directory.
The threshold argument gives the program the percentage of the file to match with
another for it to be flagged as plagiarised, and must be at least 0.4 and at most 1 
- `dir` - lists the working directory and the files that it contains
- `setdir [dir]` - sets the relative directory to look for files and resets any
results
- `results` - lists the file names for which there are results
- `results [filename]` - lists the detailed results of overlap for that file
(Make sure to include the extension of the file)
- `resultpairs` -- lists all the pairs of files for which there are positive results
- `compare [fileA] [fileB]` - prints out specific overlaps of fileA and fileB
(Make sure to include the extension of the files)
- `quit` - exits the REPL
- `help` - display the available commands

<hr>

### Usage instructions/tutorial:

1. `setdir` to folder you want to test. requirements: file names have no spaces
and all files have the same extension 
(example: `setdir tests/test1`)
2. `run` with desired params (example: `run 0.5` is the same as `run`)
3. `results` to view list of results, [results filename] to view list of
results for specific file, and [`compare A B` to compare matching patterns for
two files (example: `results Camel.txt`)

    Example for runnning test case 1 and inspecting results:
    1. `setdir tests/test1`
    2. `run`
    3. `results/results intset.ml/compare intset1.ml intset.ml/resultpairs`

<hr>

### Other information:

#### Similarity score:
- used as a measure of how likely file A plagiarized from file B
- ratio of # matching hashes between A and B : # hashes in fingerprint for A
- overall similarity score for A is the average of all similarity scores 
for file A that are > 0.5
- threshold score for detecting possible plagiarism varies with the file type, but experimentally we determined it to be around 0.5

#### Supported languages/file formats:
 - OCaml - .ml
 - Java - .java
 - C - .c
 - Python - .py
 - English - .txt (note: english comparison does NOT account for semantics)

<hr>

Self-generated test case descriptions (test case N is in directory tests/testN):

NOTE: to replicate results, run using threshold = 0.4

1) exact duplicates - should return positive result
2) variable names changed - should return positive result
3) functions/comments reordered  - should return positive result
4) functions1.ml is a copy of functions.ml but with large sections deleted - should return positive result for functions1 but not functions
5) different implementations of the same algorithm - should NOT return positive
result
6) completely different files - should NOT return positive result
7) functions/comments reordered  - should return positive result
8) more than 2 files - files changed respectively as follows: function/variable names changed; random spaces/new lines added; rec declarations/ match statement lines changed - should return positive result for all files except for lab034.ml which is a dummy.
9) more than 2 files - files changed respectively as follows: same comments but different code; comments deleted and same code with variable/function names changed - should NOT return positive result for first and should return positive result for second
10) large group of all different files - should NOT return positive result
11) txt files check - files are changed respectively as follows: exact wikipedia article; edited but very similar wikipedia article; sentences shifted around of original; exact same; a file that says “camel” five times; a more hazy edit of the original - should return positive result for all except last two: “Camels.txt” and “CamelMaybeCopy.txt”
12) Java check - test for a Java file, where one file has all comments removed
13) C check - test for a C file where one file has all comments removed
14) Python check - test for a Python file, where one files has comments removed and variable names changed. 
