# Vim Plugins

This is just a collection of plugins that I use for my vim setup.

_ _ _

## Installation

If you are using version 8+, then just clone the repository into vim's built in package manager directory:

```bash
# clone directory to vim's default plugin location
git clone http://github.com/frankiebaffa/vim_plugins ~/.vim/pack
# go to directory
cd ~/.vim/pack
# initialize submodules
./bin/package.sh init all
# update submodules
./bin/package.sh update all
# install language servers for coc
./bin/package.sh install all
```

