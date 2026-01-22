#!/bin/sh

# apt-get update & apt-get upgrade 
sudo apt-get update && sudo apt-get upgrade -y

echo 'Remove Applications'

sudo apt-get remove google-chrome-stable
