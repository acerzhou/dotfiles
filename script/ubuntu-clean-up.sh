`!/usr/bin/env bash

# Optional removal of Google Chrome; unrelated packages are left in place.
set -euo pipefail
sudo apt-get remove google-chrome-stable
