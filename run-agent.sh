#!/bin/bash

check() {
   if [[ $? != 0 ]]; then
      echo "Error! Stopping the script."
      exit 1
   fi
}

configure() {
  if [ $2 ]; then
    echo "run agent.sh configure" $1 $2
    ${AGENT_DIST}/bin/agent.sh configure $1 $2; check
  fi
}

prepare_conf() {
    echo "Will prepare agent config" ;
    cp -p ${AGENT_DIST}/conf_dist/*.* ${CONFIG_DIR}/; check
    cp -p ${CONFIG_DIR}/buildAgent.dist.properties ${CONFIG_DIR}/buildAgent.properties; check
    configure --server-url ${SERVER_URL}
    configure --auth-token ${AGENT_TOKEN}
    configure --name ${AGENT_NAME}
    echo "File buildAgent.properties was created and updated" ;
}

AGENT_DIST=/opt/buildagent

CONFIG_DIR=/data/teamcity_agent/conf

LOG_DIR=/opt/buildagent/logs

chmod +x ${AGENT_DIST}/bin/*.sh; check

rm -f ${LOG_DIR}/*.pid

if [ "${SERVER_URL}" ]; then
   echo "TeamCity URL is provided: ${SERVER_URL}"
else
   echo "TeamCity URL is not provided, but is required."
   exit 1
fi

if [ -f ${CONFIG_DIR}/buildAgent.properties ] ; then
   echo "File buildAgent.properties was found in ${CONFIG_DIR}" ;
else
   echo "Will create new buildAgent.properties using distributive" ;
   prepare_conf
fi

${AGENT_DIST}/bin/agent.sh start

while [ ! -f ${LOG_DIR}/teamcity-agent.log ];
do
   echo -n "."
   sleep 1
done

trap "${AGENT_DIST}/bin/agent.sh stop" SIGINT SIGTERM SIGHUP

touch /root/anchor

tail -qf ${LOG_DIR}/teamcity-agent.log /root/anchor &
wait