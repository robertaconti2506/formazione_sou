#!/usr/bin/env bash 

set -e 

echo "Avvio controllo migrazione echo-server"

ansible-playbook -i /vagrant/inventory.ini /vagrant/migrate.yml
