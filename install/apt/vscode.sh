#!/usr/bin/env/sh
curl -sSL https://packages.microsoft.com/keys/microsoft.asc -o microsoft.asc
gpg --no-default-keyring --keyring ./ms_vscode_key_temp.gpg --import ./microsoft.asc
gpg --no-default-keyring --keyring ./ms_vscode_key_temp.gpg --export > ./ms_vscode_key.gpg
sudo mv ms_vscode_key.gpg /etc/apt/trusted.gpg.d/

echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt upgrade 

sudo apt install -y code
