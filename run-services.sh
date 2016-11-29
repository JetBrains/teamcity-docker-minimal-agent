#!/bin/bash

echo '/run-services.sh'

for entry in /services/*.sh
do
  echo $entry
  if [ -f $entry ]; then
      chmod +x $entry; sync;
      $entry
  fi
done

echo '/run-agent.sh'
exec /run-agent.sh
