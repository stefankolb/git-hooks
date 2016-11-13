#!/bin/bash
#
# Executes the JSHint tool before a commit. All currently staged files that 
# have the suffix .js will be checked against the specified .jshintrc
# 
# Released unter the MIT License:
#
# Copyright (c) 2016 Stefan Kolb
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is 
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.

# Configuration
JSHINTRC="" # Insert full path to your config file, e.g. /my/path/to/.jshintrc
TAG="[git-hook][jshint]"
FAIL=FALSE

printf "\n${TAG} Executing pre-commit hook jshint\n"

# Determine the currently staged files
FILES_JSHINT=$(git diff --cached --name-only --diff-filter=ACMR | grep "\.js$");

# Check if we have files to run against JSHint
if [ -z "${FILES_JSHINT}" ]; then
  echo "${TAG} No .js-files currently staged -> skipping JSHint"
  exit 0;
fi

# Run each currently staged .js-file against ESLint
for FILE in ${FILES_JSHINT}; do
  RESULT_JSHINT=$(jshint -c ${JSHINTRC} ${FILE})
  if [ ! -z "${RESULT_JSHINT}" ]; then
    echo "${TAG} File ${FILE} did not pass JSHint checks"
    FAIL=TRUE
  fi
done

# Done
if [ ${FAIL} == TRUE ]; then
  echo "${TAG} JSHINT checks not passed -> aborting commit"
  exit 1;
fi

exit 0;
