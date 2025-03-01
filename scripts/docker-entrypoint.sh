#!/bin/bash
set -e

# A lot of the following is taken from https://steinborn.me/posts/tuning-minecraft-openj9/
# Which is licensed under the MIT license. 

if [[ "$1" = 'serve' ]];  then
  
  NURSERY_MINIMUM=$(($JAVA_HEAP_SIZE / 2))
  NURSERY_MAXIMUM=$(($JAVA_HEAP_SIZE * 4 / 5))

  echo "Starting the server with ${JAVA_HEAP_SIZE}M allocated heap in ${SERVER_PATH} using the jar ${SERVER_PATH}/paper.jar!"

  # Start server
  COMMAND="java ${JAVA_ARGS} -Xmx${JAVA_HEAP_SIZE}M -Xms${JAVA_HEAP_SIZE}M \
    -Xmns${NURSERY_MINIMUM}M -Xmnx${NURSERY_MAXIMUM}M \
    -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc \
    -jar ${SERVER_PATH}/paper.jar \
    ${SPIGOT_ARGS} \
    --bukkit-settings ${CONFIG_PATH}/bukkit.yml --plugins ${PLUGINS_PATH} --world-dir ${WORLDS_PATH} --spigot-settings ${CONFIG_PATH}/spigot.yml --commands-settings ${CONFIG_PATH}/commands.yml --config ${PROPERTIES_LOCATION} \
    --paper-settings ${CONFIG_PATH}/paper.yml \
    ${PAPERSPIGOT_ARGS}"
  echo "Using command: ${COMMAND}"
	
  ${COMMAND}

  echo "The server was shutdown!"

fi

exec "$@"
