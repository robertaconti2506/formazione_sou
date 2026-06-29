#!/usr/bin/env bash

# stop se fallisce un comando
set -e

# Assegno alla variabile "FILE" il percorso del file state.json
FILE="/opt/coffee-monitor/state.json"

# Se il file non esiste, inizializza lo stato
if [ ! -f "$FILE" ]; then
  echo '{"status":"ON","water":80,"coffee":95,"temperature":92,"cups":0}' > "$FILE"
fi

# Lettura valori attuali
STATUS=$(jq -r '.status // "ON"' "$FILE")
WATER=$(jq -r '.water // 0' "$FILE")
COFFEE=$(jq -r '.coffee // 0' "$FILE")
TEMP=$(jq -r '.temperature // 92' "$FILE")
CUPS=$(jq -r '.cups // 0' "$FILE")

# Se la macchina era OFF, riparte dallo stato iniziale
if [ "$STATUS" = "OFF" ]; then
  WATER=80
  COFFEE=95
  TEMP=92
  CUPS=0
  STATUS="ON"
fi

# Simulazione consumo
if [ "$WATER" -gt 0 ]; then
  WATER=$((WATER -1))
fi

if [ "$COFFEE" -gt 0 ]; then
  COFFEE=$((COFFEE -1))
fi

# Simulazione temperatura
TEMP=$((TEMP + RANDOM % 4))

CUPS=$((CUPS + 1))

# Stato ON/OFF
if [ "$WATER" -gt 0 ] &&
   [ "$COFFEE" -gt 0 ] &&
   [ "$TEMP" -le 100 ] &&
   [ "$CUPS" -le 100 ]; then
  STATUS="ON"
else
  STATUS="OFF"
fi


# Aggiornamento file (dopo utilizzo)
cat > "$FILE" << EOF
{
  "status":"$STATUS",
  "water":$WATER,
  "coffee":$COFFEE,
  "temperature":$TEMP,
  "cups":$CUPS
}
EOF

# Aggiornamento pagina web
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8">
<title>Coffee --status</title>

<style>
body{
    margin:0;
    font-family:Arial, Helvetica, sans-serif;
    background:#f3e8d2;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.container{
    width:420px;
    background:#fffdf8;
    border-radius:18px;
    padding:30px;
    box-shadow:0 10px 25px rgba(0,0,0,.15);
}

h1{
    margin:0;
    text-align:center;
    color:#4b2e1e;
    font-size:34px;
}

.line{
    height:1px;
    background:#d9c7aa;
    margin:20px 0;
}

.card{
    display:flex;
    justify-content:space-between;
    align-items:center;
    background:#faf6ef;
    padding:14px 18px;
    margin:12px 0;
    border-radius:10px;
}

.label{
    font-weight:bold;
    color:#5b4636;
}

.value{
    font-weight:bold;
    color:#3d2a1f;
}
</style>

</head>

<body>

<div class="container">

<h1>☕ Coffee --status</h1>

<div class="line"></div>

<div class="card">
    <span class="label">Status</span>
    <span class="value">$STATUS</span>
</div>

<div class="card">
    <span class="label">Water</span>
    <span class="value">${WATER}%</span>
</div>

<div class="card">
    <span class="label">Coffee</span>
    <span class="value">${COFFEE}%</span>
</div>

<div class="card">
    <span class="label">Temperature</span>
    <span class="value">${TEMP} °C</span>
</div>

<div class="card">
    <span class="label">Cups</span>
    <span class="value">${CUPS}</span>
</div>

</div>

</body>
</html>
EOF
