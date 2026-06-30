#!/usr/bin/env bash


# Controllo numero di argomenti
if [[ $# -ne 3 ]]; then 
	echo "Hai inserito un numero sbagliato di argomenti"
	exit 1
fi 


# ip da linea di comando (primo argomento) 
ip=$1

# Estremi del range da linea di comando (secondo e terzo argomento)
start=$2
end=$3


# Funzione per verificare che sia stato inserito un indirizzo IP 
validate_ip() {
	if [[ -z "$ip" || ! "$ip" =~ ^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$ ]]; then
		echo "IP non valido"
    		exit 1
	fi
}

# Funzione per verificare che sia stata inserita una porta esistente e un range possibile
validate_port() {
    if ! [[ $start =~ ^[0-9]+$ ]] || ! [[ $end =~ ^[0-9]+$ ]]; then
        echo "Input non valido"
        exit 1
    fi

    if [ "$start" -lt 1 ] || [ "$end" -gt 65535 ] || [ "$start" -gt "$end" ]; then
        echo "Range porte non valido"
        exit 1
    fi
}

# Eseguo le funzioni
validate_ip
validate_port



echo "Controllo della raggiungibilità tra le due macchine" 
echo 
if ! ping -c 2 -W 2 "$ip">/dev/null 2>&1 ; then
	echo "ping fallito"
fi


# Ciclo for per eseguire lo scanner su tutte le porte del range (TCP)
for (( port=start; port<=end; port++ )); do
	if nc -w 1 "$ip" "$port" < /dev/null >/dev/null 2>&1; then
#	if nc -w 1 "$ip" "$port" >/dev/null 2>&1; then
		echo "Porta $port aperta"
	else
       	 	echo "Porta $port chiusa"
	fi
done
