 #!/usr/bin/env sh
 
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root privileges. Restarting with sudo..."
    sudo "$(realpath $0)" "$@"
    exit $?
else
    # Your script's main logic goes here
    echo "You are root! Proceeding with the script."
fi

# Remove snap
snap remove firefox
apt remove firefox -y 


install -d -m 0755 /etc/apt/keyrings

# Get keyring and add source
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list

# Pin package
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt update -y && sudo apt install -t 'o=LP-PPA-mozillateam' firefox -y
