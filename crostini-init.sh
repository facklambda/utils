#!/bin/bash
echo "updating and upgrading base system"
sudo apt-get update
sudo apt-get upgrade -y
echo "installing build-essential and other deps"
sudo apt-get install apt-transport-https build-essential pkg-config libssl-dev micro -y


echo "Installing GitHub CLI"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update
sudo apt-get install gh -y

echo "Installing Code Insiders"

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt-get update
sudo apt-get install code-insiders -y


echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
source $HOME/.cargo/env
rustup completions bash > ~/.local/share/bash-completion/completions/rustup

echo "Installing Go"
curl --proto '=https' --tlsv1.2 -sSfLO https://go.dev/dl/go1.18.1.linux-arm64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.1.linux-arm64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.profile
source $HOME/.profile
go version

echo "Installing Micro LSP"
micro -plugin install lsp
micro -plugin install go
#git clone https://github.com/AndCake/micro-plugin-lsp ~/.config/micro/plug/lsp

echo "Installing dotfiles"
cd ~
git init
git remote add origin https://github.com/facklambda/dots.git
git fetch
git checkout -f main
