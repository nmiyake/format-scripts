format-scripts
==============
`format.sh` formats files with specific extensions to ensure that they have no trailing spaces and
that they end with a newline. The default implementation runs on files with the extensions `.yml`,
`.md` and `.sh`.

`install-git-hooks.sh` installs a Git pre-commit hook that ensures that `format.sh`
has been run on all of the files in a commit.

Usage
=====

format.sh
---------
`./format.sh` formats all files in the current directory tree that match the extensions.

`./format.sh -v` formats all files in the current directory tree that match the extensions and
outputs the files that were modified.

`./format.sh -l` lists all of the files in the current directory tree that would be modified if
`./format.sh` were run. If there are any files that would be modified, it exits with an exit code of
1.

`./format.sh -l -v` lists all of the files in the current directory tree that would be modified if
`./format.sh` were run and prints a user-friendly message informing the user that the script should
be run to format the files.

All of the above commands support being provided with a list of files that should be considered.
Such files will still be filtered such that only those with extensions that match the extensions to
be considered will be processed.

install-git-hooks.sh
--------------------
`./install-git-hooks.sh` installs a Git `pre-commit` hook that verifies that all of the relevant
files in a commit have been formatted using `./format.sh`. It should be run once to install the
pre-commit hook.

The default implementation assumes that it will be run from the root of the Git directory and that
the `format.sh` script exists in the root of the Git directory. If this is not the case, modify the
`GIT_HOOKS_DIR` variable and the `./format.sh` string to the desired location.
