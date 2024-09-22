#!/usr/bin/env sh

# Given a hosts file URL, it appends it to your /etc/hosts file 

hosts_url=${hosts_url:="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"}

tmp_file=$(mktemp)

if [ -x $(which wget) ]
then
    [ -f $tmp_file ] || wget -q -O - $hosts_url > $tmp_file
elif [ -x $(which curl) ]
then
    [ -f $tmp_file ] || curl $hosts_url > $tmp_file
fi

# Clean domains
sed -i -n 's/#.*$//g; /^0.0.0.0/p' $tmp_file 

# Get hosts that are not on /etc/hosts
comm -23 ${tmp_file} /etc/hosts 2>/dev/null > ${tmp_file}_comm

# Backup original /etc/hosts
comm -23 /etc/hosts ${tmp_file} 2>/dev/null > /tmp/hosts.bak
[ -f "/etc/hosts.bak" ] || sudo mv /tmp/hosts.bak /etc

# Append the domains to the host file
cat /etc/hosts ${tmp_file}_comm > ${tmp_file}_merge
sudo mv ${tmp_file}_merge /etc/hosts

hosts_count=$(wc -l < ${tmp_file}_comm)
echo "Appended $hosts_count hosts to /etc/hosts"

# Cleanup
rm ${tmp_file}*