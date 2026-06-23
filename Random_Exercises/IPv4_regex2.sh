#!/usr/bin/env bash


read -p "Inserisci un indirizzo IP: " ip

# Escludo tutto ciò che non è un indirizzo IPv4 
if [[ -z "$ip" || ! "$ip" =~ ^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$ ]]; then
	echo "IP non valido"
    exit 1
fi


echo "********************************" 
echo "*                              *" 
echo "* Classificazione indirizzi IP *"
echo "*                              *"
echo "********************************"


echo "*                              *"

# classificazione di indirizzi privati, pubblici o riservati
if [[ "$ip" =~ ^(10\..+\..+\..+)$|^(172\.(1[6-9]|2[0-9]|3[0-1])(\.[0-9]{1,3}){2})$|^(192\.168\..+\..+)$ ]]; then
	echo "*       privato                *" 
elif [[ "$ip" =~ ^(127)\..+\..+\..+$|^(169\.254)\..+\..+$|0\.0\.0\.0$  ]]; then 
	echo "*       riservato              *"
else 
	echo "*       pubblico               *"
fi


# classificazione in base al primo ottetto 
if [[ "$ip" =~ 0\.0\.0\.0 ]]; then 
	echo "*       jolly                  *"
elif [[ "$ip" =~ ^([1-9][0-9]?|1[0-1][0-9]|12[0-6])\..+\..+\..+$ ]]; then 
	echo "*       classe A               *"
elif [[ "$ip" =~ ^(127)\..+\..+\..+$ ]]; then 
	echo "*       indirizzo di loopback  *"
elif [[ "$ip" =~ ^(12[8-9]|1[3-8][0-9]|19[0-1])\..+\..+\..+$ ]] && [[ ! "$ip" =~ ^169\.254\..+\..+$ ]]; then 
	echo "*       classe B               *" 
elif [[ "$ip" =~ ^(169\.254)\..+\..+$ ]]; then 
	echo "*       APIPA                  *"
elif [[ "$ip" =~ ^(19[2-9]|2[0-1][0-9]|22[0-3])\..+\..+\..+$ ]]; then
	echo "*       classe C               *" 
elif [[ "$ip" =~ ^(22[4-9]|23[0-9])\..+\..+\..+$ ]]; then 
	echo "*       classe D               *" 
elif [[ "$ip" =~ ^(24[0-9]|25[0-5])\..+\..+\..+$ ]]; then 
	echo "*       classe E               *" 
fi 



echo "*                              *"
echo "********************************"
