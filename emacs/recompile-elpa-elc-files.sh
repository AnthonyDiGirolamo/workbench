#!/usr/bin/zsh

if test -n "$BASH"; then
  EMACS_ROOT=$(dirname "${BASH_SOURCE[0]}")
elif test -n "$ZSH_NAME"; then
  EMACS_ROOT="${0:h:A}"
fi

cd $EMACS_ROOT

rm -f $EMACS_ROOT/README.el
rm -f $EMACS_ROOT/cache/autoload*
rm -f $EMACS_ROOT/package-quickstart.el*

find $EMACS_ROOT/elpa/ -iname "*.elc" -delete
find $EMACS_ROOT/elpa/ -maxdepth 1 -type d -empty -delete

emacs -Q --batch --eval "(byte-recompile-directory \"$EMACS_ROOT/elpa/\" 0 t)"

time emacs --init-directory $EMACS_ROOT -nw --eval '(progn (package-quickstart-refresh) (save-buffers-kill-terminal))'
time emacs --init-directory $EMACS_ROOT -nw --eval '(save-buffers-kill-terminal)'
