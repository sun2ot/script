add-apt-repository ppa:git-core/ppa
add-apt-repository ppa:trzsz/ppa
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

sudo apt update
sudo apt -y install git git-lfs zsh trzsz rsync

echo -e "\e[1m\e[32m(git, git-lfs, zsh, trzsz)\e[0m has been installed."