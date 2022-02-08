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
# update submodules
bin/./update
# install language servers for coc
bin/./install all
```

## Adding new language servers

To add new language servers do the following:

```bash
# go to directory
cd ~/.vim/pack
# script will add repository as a submodule and add name/path to ls.csv file
# example values:
#   GIT_USERNAME=neoclide
#   GIT_REPO_NAME=coc-tsserver
#   DESIRED_REFERENCE_NAME=typescript
bin/./add_lang_server $GIT_USERNAME $GIT_REPO_NAME $DESIRED_REFERENCE_NAME
# script will install the submodule using `yarn install --frozen-lockfile`
bin/./install $DESIRED_REFERENCE_NAME
```

