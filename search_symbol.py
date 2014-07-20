import re, sys, commands, getopt

def usage():
    print "usage: cmd [-C] word file0 [file1 ...]"

if len(sys.argv) <= 2:
    usage()
    sys.exit(1)

nmOpt = []

try:
    opts, argv = getopt.getopt(sys.argv[1:], "C", [])
except getopt.GetoptError:
    usage()
    sys.exit(2)
for o, a in opts:
    if o == "-C":
        nmOpt.append(o)

word = argv[0]
for lib in argv[1:]:
    (rv, out) = commands.getstatusoutput("nm " + " ".join(nmOpt) + " " + lib)
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
