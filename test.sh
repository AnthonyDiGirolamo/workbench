#!/usr/bin/bash -x

for f in $(ls *.org); do
	! test -f $f.last && continue
	cat $f.last | sort > $f.1
	cat $f | sort > $f.2
	for removed in $(diff -u $f.1 $f.2 | grep -E '^-[^-].*' | sed -e 's/^-\(.*\)/\1/'); do
		test -f $removed && rm -i $removed
	done
	rm $f.1 $f.2
done
exit 0
