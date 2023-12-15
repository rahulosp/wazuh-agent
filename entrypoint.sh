#!/bin/bash

# change certain values in your config
sed -i "s/MANAGER_IP/$MANAGER_IP/g" /var/ossec/etc/ossec.conf
sed -i "s/MANAGER_PORT/$MANAGER_PORT/g" /var/ossec/etc/ossec.conf
sed -i "s/MANAGER_PROTOCOL/$MANAGER_PROTOCOL/g" /var/ossec/etc/ossec.conf
# Start the agent
/var/ossec/bin/wazuh-control start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start agent: $status"
  exit $status
fi

echo "background jobs running, listening for changes"

while sleep 60; do
  /var/ossec/bin/wazuh-control status > /dev/null 2>&1
  status=$?
  if [ $status -ne 0 ]; then
    echo "looks like the agent died."
    exit 1
  fi
done
