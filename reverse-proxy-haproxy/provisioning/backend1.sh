#!/usr/bin/env bash 


# risposte automatiche predefinite per prompt interattivi 
export DEBIAN_FRONTEND=noninteractive 


# stop se fallisce un comando 
set -e 


# aggiornamento dei pacchetti 
apt-get update -y 


# nginx 
apt-get install -y nginx 
systemctl enable nginx 
systemctl start nginx 

# file html per pagina web
cat <<EOF > /var/www/html/index.html 
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Server Giorno</title>

  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #87CEEB, #f7f7f7);
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .box {
      background: white;
      padding: 40px;
      border-radius: 12px;
      width: 320px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }

    h1 {
      text-align: center;
      margin-bottom: 20px;
      color: #333;
    }

    label {
      font-size: 13px;
      margin-top: 10px;
      display: block;
      color: #444;
    }

    input {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border-radius: 6px;
      border: 1px solid #ccc;
      outline: none;
    }

    button {
      width: 100%;
      margin-top: 20px;
      padding: 10px;
      border: none;
      border-radius: 6px;
      background: #f4a261;
      color: white;
      cursor: pointer;
    }

    button:hover {
      background: #e76f51;
    }
  </style>
</head>

<body>
  <div class="box">
    <h1>Benvenuto</h1>

    <label>Username</label>
    <input type="text" placeholder="Inserisci username">

    <label>Password</label>
    <input type="password" placeholder="Inserisci password">

    <button>Accedi</button>
  </div>
</body>
</html>
EOF

# il proprietario del filee il gruppo di appartenenza saranno l'utente del server web
chown www-data:www-data /var/www/html/index.html


# firewall
apt-get install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow from 192.168.56.13 to any port 80 proto tcp
ufw --force enable
