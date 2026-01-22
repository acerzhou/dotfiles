#!/bin/sh

# update apt 
sudo apt update && sudo apt upgrade -y

echo 'Install Applications'

function install_chrome(){
    echo 'Install Chrome'
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
    sudo dpkg -i google-chrome-stable_current_amd64.deb &&
    rm -f google-chrome-stable_current_amd64.deb
}

function install_slack(){
    echo 'Install Slack'
    sudo snap install slack --classic
}

function install_zoom(){
    echo 'Install Zoom'
    wget https://zoom.us/client/latest/zoom_amd64.deb &&
    sudo apt install ./zoom_amd64.deb
    rm -f zoom_amd64.deb
}

function install_notion(){
    echo 'Install Notion'
    sudo snap install notion-snap
}

function install_vscode(){
    echo 'Install VS Code'
    sudo snap install --classic code
}

function install_docker(){
    echo 'Install Docker'
    sudo apt install ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt install docker-ce docker-ce-cli containerd.io
}


