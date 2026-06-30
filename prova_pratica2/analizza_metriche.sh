#!/usr/bin/env bash 

declare -A counter_server
declare -A somma_cpu

read -p "Inserisci un file: " file

if [[ ! -f "$file" ]]; then 
	echo "Il file non esiste" 
	exit 1
fi 	

while read -r server percentuale ; do
        (( somma_cpu[$server] += percentuale ))
        (( counter_server[$server]++ ))
done < $file

echo 

echo "=== REPORT UTILIZZO MEDIO CPU ==="

echo 

for server in "${!somma_cpu[@]}" ; do # restituisce tutte le chiavi dell'array (!) 
        media=$((somma_cpu[$server]/counter_server[$server]))
        echo "$server: $media%"
        echo    
done                         
