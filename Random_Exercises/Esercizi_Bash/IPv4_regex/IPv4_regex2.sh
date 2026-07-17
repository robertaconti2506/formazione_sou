#!/usr/bin/env bash


read -p "Inserisci un indirizzo IP: " ip

# Escludo tutto ciò che non è un indirizzo IPv4 
if [[ -z "$ip" || ! "$ip" =~ ^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$ ]]; then
	echo "IP non valido"
    exit 1
fi


IFS="." read -r o1 o2 o3 o4 <<< "$ip"


# Classificazione degli indirizzi (privati, pubblici e riservati) 
if [[ "$o1" -eq 0 && "$o2" -eq 0 && "$o3" -eq 0 && "$o4" -eq 0 ]]; then 
	echo "Indirizzo riservato, jolly" 
elif [[ "$o1" -eq 10 ]]; then 
	echo "Indirizzo privato"
elif [[ "$o1" -eq 127 ]]; then
	echo "Indirizzo riservato, di loopback" 
elif [[ "$o1" -eq 169 && "$o2" -eq 254 ]]; then 
	echo "Indirizzo riservato, APIPA" 
elif [[ "$o1" -eq 172 && "$o2" -ge 16 && "$o2" -lt 32 ]]; then 
	echo "Indirizzo privato"
elif [[ "$o1" -eq 192 && "$o2" -eq 168 ]]; then 
	echo "Indirizzo privato"
else 
	echo "Indirizzo pubblico"
fi


# Classificazione in base al primo ottetto 
if [[ "$o1" -ge 1 && "$o1" -le 126  ]]; then 
	echo "classe A"
elif [[ "$o1" -ge 128 && "$o1" -le 191 ]] && [[ "$o1" -ne 169 || "$o2" -ne 254 ]]; then 
	echo "classe B" 
elif [[ "$o1" -ge 192 && "$o1" -le 223 ]]; then
	echo "classe C" 
elif [[ "$o1" -ge 224 && "$o1" -le 239 ]]; then 
	echo "classe D" 
elif [[ "$o1" -ge 240 && "$o1" -le 255 ]]; then 
	echo "classe E" 
fi 

