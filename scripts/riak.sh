#! /bin/sh

# Ensure correct ownership and permissions on volumes
chown riak:riak /var/lib/riak /var/log/riak
chmod 755 /var/lib/riak /var/log/riak

# Open file descriptor limit
ulimit -n 4096

IP_ADDRESS=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1 |  sed -n 2p)
# Ensure the Erlang node name is set correctly
sed -i.bak "s/riak@127.0.0.1/riak@${IP_ADDRESS}/" /etc/riak/riak.conf
rm  -rf /var/lib/riak/ring/*

# Start Riak
exec /sbin/setuser riak "$(ls -d /usr/lib/riak/erts*)/bin/run_erl" "/tmp/riak" \
   "/var/log/riak" "exec /usr/sbin/riak console"
