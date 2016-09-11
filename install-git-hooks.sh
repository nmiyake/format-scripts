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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GIT_HOOKS_DIR="$(cd "$SCRIPT_DIR/.git/hooks" && pwd)"

if [ ! -d "$GIT_HOOKS_DIR" ]; then
    echo "Git hooks directory does not exist at $GIT_HOOKS_DIR"
    exit 1
fi

read -d '' CONTENT <<"EOF" || true
files=$(git diff --cached --name-only --diff-filter=ACM)
[ -z "$files" ] && exit 0
./format.sh -l -v $files
EOF

PRECOMMIT_FILE="$GIT_HOOKS_DIR/pre-commit"
echo "$CONTENT" > "$PRECOMMIT_FILE"
chmod 755 "$PRECOMMIT_FILE"
