#!/bin/bash
#Use with user root


sudo wget https://github.com/TuNGO-86/script/releases/download/v1.0/agentPackages.zip
sudo apt install unzip
sudo unzip agentPackages.zip
sudo chmod +x install.sh
./install.sh -i
echo "Installation succeeded!"
