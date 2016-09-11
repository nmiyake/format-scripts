#!/bin/bash

# MIT License
#
# Copyright (c) 2016 Nick Miyake
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -eu -o pipefail

LIST=false
VERBOSE=false
while getopts "lv" opt; do
    case $opt in
      l)
          LIST=true
          ;;
      v)
          VERBOSE=true
          ;;
      \?)
          echo "Invalid option: -$OPTARG" >&2
          exit 1
          ;;
    esac
done
shift "$((OPTIND - 1))"

INPUT=($@)
# if input is empty, find all files
if [ "${#INPUT[@]}" = 0 ]; then
    INPUT=($(find .))
fi

# if no files exist, exit
if [ "${#INPUT[@]}" = 0 ]; then
    exit 0
fi

FILES=()
for f in "${INPUT[@]}"; do
    case $f in
        *.yml|*.md|*.sh)
            ;;
        *)
            # skip files that do not match extension
            continue
            ;;
    esac;

    # skip files that are formatted correctly
    if [ -z $(grep -li '[[:space:]]$' "$f") ] && [ -z "$(tail -c 1 "$f")" ]; then
        continue
    fi

    # record files that are not formatted properly
    FILES+=("$f")

    # if in list mode, continue after recording file
    if [ "$LIST" = true ]; then
        continue
    fi

    # remove trailing whitespace and ensure that file ends in newline
    sed -i '' -e $'s/[[:space:]]*$//g' $f
    sed -i '' -e '$a\' $f

    if [ "$VERBOSE" = true ]; then
        echo "$f"
    fi
done

if [ "${#FILES[@]}" = 0 ]; then
    exit 0
fi

if [ "$LIST" = true ]; then
    SPACER=""
    if [ "$VERBOSE" = true ]; then
        echo "The following files are not formatted correctly:"
        SPACER="  "
    fi

    for f in "${FILES[@]}"; do
        echo "$SPACER$f"
    done

    if [ "$VERBOSE" = true ]; then
        echo "Run $0 to format them."
    fi

    exit 1
fi
