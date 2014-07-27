#!/usr/bin/env python

import os

home = os.environ["HOME"]
BUNDLE = home + "/.vim/bundle"

if not os.path.exists(BUNDLE):
    os.system("mkdir -p ~/.vim/autoload " + BUNDLE)
    os.system("curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim")

urlList = [
        "https://github.com/katonori/binedit.vim",
        "https://github.com/katonori/poslist.vim",
        "https://github.com/katonori/vicmake.vim",
        "https://github.com/tpope/vim-fugitive",
        "https://github.com/katonori/vimsvn.vim",
        "https://github.com/LeafCage/yankround.vim.git",
        "https://github.com/troydm/easybuffer.vim",
        "https://github.com/vim-scripts/MultipleSearch",
        "https://github.com/katonori/ps.vim",
        "https://github.com/Shougo/unite.vim",
        "https://github.com/Lokaltog/vim-easymotion",
        "https://github.com/vim-scripts/mru.vim",
        "https://github.com/Shougo/neocomplcache.vim",
        "https://github.com/Shougo/neosnippet.vim",
        "https://github.com/honza/vim-snippets",
        "https://github.com/tomtom/quickfixsigns_vim",
        "https://github.com/katonori/regex_efm.vim",
        ]

for url in urlList:
    bn = os.path.basename(url)
    tgt_dir = BUNDLE + "/" + bn
    if not os.path.exists(tgt_dir):
        cmd = "git clone %s %s"%(url, tgt_dir)
        print "cmd: "  + cmd
        os.system(cmd)
