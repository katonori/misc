import re
import sys
import commands

if len(sys.argv) <= 2:
    print "usage: cmd word file0 [file1 ...]"
    sys.exit(1)

word = sys.argv[1]
for lib in sys.argv[2:]:
    (rv, out) = commands.getstatusoutput("nm -C " + lib)
    objName = ""
    for l in out.split("\n"):
        m = re.match(r"^(\S+):", l)
        if m:
            objName = m.group(1)
        else:
            m = re.search(word, l)
            if m:
                print "%s: %s: "%(lib, objName),
                print l
