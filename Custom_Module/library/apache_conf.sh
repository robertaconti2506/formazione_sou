#!/bin/bash
# WANT_JSON

IP=$(jq -r '.ip // empty' "$1")
PORT=$(jq -r '.port // empty' "$1")
INDEX=$(jq -r '.index // empty' "$1")

CONFIG="/etc/apache2/sites-enabled/000-default.conf"
TESTO=$(cat "/var/www/html/index.html")
CHANGED=false

if [ -z "$IP" ]; then
  cat << EOF
{
  "failed": true,
  "msg": "Argomento non passato"
}
EOF
  exit 1
fi

if ! [[ $IP =~ ^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$ ]]; then
  cat << EOF
{
  "failed": true,
  "msg": "IP non valido"
}
EOF
  exit 1
fi

if [ -z "$PORT" ]; then
  cat << EOF
{
  "failed": true,
  "msg": "Argomento non passato"
}
EOF
  exit 1
fi

if [ -z "$INDEX" ]; then
  cat << EOF
{
  "failed": true,
  "msg": "Argomento non passato"
}
EOF
  exit 1
fi

if ! dpkg -l | grep -q apache2; then
    apt install -y apache2
    CHANGED=true
fi

if [ "$TESTO" != "$INDEX" ]; then
  echo "$INDEX" > /var/www/html/index.html
  CHANGED=true
fi

if grep -q "<VirtualHost $IP:$PORT>" "$CONFIG"; then
  echo "Configurazione già corretta"
else
  sed -i "s/<VirtualHost .*/<VirtualHost $IP:$PORT>/" "$CONFIG"
  CHANGED=true
fi

systemctl restart apache2

STATUS=$(systemctl is-active apache2 2>/dev/null)
if [ "$STATUS" = "active" ]; then
  IS_ACTIVE="true"
else
  IS_ACTIVE="false"
fi

cat << EOF
{
  "changed": $CHANGED,
  "failed": false,
  "active": "$IS_ACTIVE",
  "state": "$STATUS",
  "ip": "$IP",
  "porta": "$PORT"
}
EOF
