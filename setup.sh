#!/bin/sh

SHELL_INIT=~/.zshrc

#
# Zsh
#
echo "------------------------------"
echo "Setting up zsh."
sudo apt-get -y install zsh
sudo chsh ubuntu -s $(which zsh)
echo "------------------------------"
echo "Setting up oh-my-zsh." 
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#
# Go Setup
#
echo "------------------------------"
echo "Setting up go."
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get -y golang
echo GOROOT=/usr/lib/go-1.8 | tee -a $SHELL_INIT
echo GOPATH=/home/ubuntu/go | tee -a $SHELL_INIT

#
# Node.js Setup
#
echo "------------------------------"
echo "Setting up nodejs."
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

#
# Python setup
#
echo "------------------------------"
echo "Setting up pip."
sudo apt install -y python-setuptools
sudo easy_install pip
sudo -H pip install virtualenv
sudo -H pip install virtualenvwrapper
EXTRA_PATH=~/.extra
echo $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "# Source virtualenvwrapper, added by setup.sh" >> $EXTRA_PATH
echo "export WORKON_HOME=~/.virtualenvs" >> $EXTRA_PATH
echo "source /usr/local/bin/virtualenvwrapper.sh" >> $EXTRA_PATH
echo "source $EXTRA_PATH" >> $SHELL_INIT
source $EXTRA_PATH
mkvirtualenv py2-default

echo "------------------------------"
echo "Setting up awscli."
workon py2-default
pip install awscli

#
# Google Cloud
#
echo "------------------------------"
echo "Setting up gcloud cli."
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt install -y google-cloud-sdk

#
# VIM
#
echo "------------------------------"
echo "Setting up vim plugins."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cat << EOF > ~/.vimrc
set number
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
let g:netrw_liststyle=3
call plug#begin()
call plug#end()
EOF

#
# Mosh shell
#
sudo apt-get install -y mosh