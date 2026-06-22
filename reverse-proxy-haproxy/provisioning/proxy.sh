#!/usr/bin/env bash 


# risposte predefinite per prompt interattivi 
export DEBIAN_FRONTEND=noninteractive


# stop se fallisce un comando 
set -e 


# aggiornamento pacchetti 
apt-get update -y 


# certificato self-signed x509 
apt-get install -y haproxy openssl 

# crea la cartella per i certificati HAProxy
mkdir -p /etc/haproxy/certs 

# genera il certificato 
# - req x509, crea il certificato
# - newkey rsa:2048, crea una nuova chiave 
# - nodes, la chiave non viene cifrata (no DES)
# -keyout /../../../haproxy.key, percorso della chiave privata 
# -out, certificato pubblico 
# - days 365, scadenza tra un annp 
#- sybj, dati del certificato 
openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/haproxy/certs/haproxy.key -out /etc/haproxy/certs/haproxy.crt -days 365 -subj "/C=IT/ST=Lazio/L=Rome/O=DevOps/CN=proxyrev" 

# certificato e chiave in un unico file
cat /etc/haproxy/certs/haproxy.crt /etc/haproxy/certs/haproxy.key > /etc/haproxy/certs/haproxy.pem

# copia la configurazione di HAProxy da Vagrant
cp /vagrant/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg 

# controllo sintassi
haproxy -c -f /etc/haproxy/haproxy.cfg 

# enable e avvio per haproxy
systemctl enable haproxy 
systemctl restart haproxy 
