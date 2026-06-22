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
  <title>Server Notte</title>

  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: radial-gradient(circle at top, #1b2a4a, #05070f);
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .box {
      background: #111827; /* più scuro ma distinto dallo sfondo */
      padding: 45px;
      border-radius: 14px;
      width: 340px;

      /* contrasto forte */
      box-shadow: 0 0 0 1px rgba(255,255,255,0.08),
                  0 20px 40px rgba(0,0,0,0.7);
    }

    h1 {
      text-align: center;
      margin-bottom: 25px;
      color: #ffffff;
      letter-spacing: 1px;
    }

    label {
      font-size: 13px;
      margin-top: 12px;
      display: block;
      color: #cbd5e1;
    }

    input {
      width: 100%;
      padding: 11px;
      margin-top: 6px;
      border-radius: 8px;
      border: 1px solid #2a2f45;
      background: #0b1220;
      color: white;
      outline: none;
    }

    input:focus {
      border-color: #4cc9f0;
      box-shadow: 0 0 0 2px rgba(76,201,240,0.2);
    }

    button {
      width: 100%;
      margin-top: 22px;
      padding: 11px;
      border: none;
      border-radius: 8px;
      background: #4cc9f0;
      color: #0b1220;
      cursor: pointer;
      font-weight: bold;
      transition: 0.2s;
    }

    button:hover {
      background: #4895ef;
    }
  </style>
</head>

<body>
  <div class="box">
    <h1>Benvenuto</h1>

    <label>Username</label>
    <input type="text" placeholder="Username">

    <label>Password</label>
    <input type="password" placeholder="Password">

    <button>Accedi</button>
  </div>
</body>
</html>
EOF

# il proprietario del filee il gruppo di appartenenza saranno l'utente del server web (www-data)
chown www-data:www-data /var/www/html/index.html 


# firewall 
apt-get install -y ufw 
ufw default deny incoming 
ufw default allow outgoing 
ufw allow ssh 
ufw allow from 192.168.56.13 to any port 80 proto tcp 
ufw --force enable
