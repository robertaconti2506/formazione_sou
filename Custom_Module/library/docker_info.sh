#!/bin/bash

# Controllo Docker 
if ! command -v docker &>/dev/null; then 
  cat << EOF
{ 
  "changed": false,
  "failed": true,
  "msg": "Docker non installato"
} 
EOF
  exit 1
fi


# Informazioni su Docker che voglio dalla macchina remota
# Eseguo dei comandi e salvo l'output in delle variabili
DOCKER_VERSION=$(docker --version)
RUNNING_CONTAINERS=$(docker ps -q | wc -l)
IMAGES_NUMBER=$(docker images -q |  wc -l)
DOCKER_NETWORK=$(docker network ls -q | wc -l )


# Ritorno un json ad ansible
# changed: false perchè il modulo non tocca nulla
# i return value devono essere sempre almeno changed, failed, quello che vogliamo
cat << EOF
{
  "changed": false,
  "failed": false,
  "docker_version": "$DOCKER_VERSION",
  "running_containers": "$RUNNING_CONTAINERS",
  "images_number": "$IMAGES_NUMBER",
  "docker_network": "$DOCKER_NETWORK"
}
EOF

