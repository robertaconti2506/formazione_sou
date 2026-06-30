#!/usr/bin/env bash 


# Funzione che definisce se un numero è pari o dispari controllando il resto della divisione per due
even_odd() {
        if (( $1 % 2 == 0 )); then
                echo "$1 è un numero pari"
        else
                echo "$1 è un numero dispari"
        fi
}

# Verifica se il numero degli argomenti è giusto (uno) e se è stato inserito un numero
if (( $# != 1 )) ||  [[ ! $1 =~ ^[1-9][0-9]*$ ]]; then 
	echo "Hai inserito un numero sbagliato di argomenti o un argomento non valido"
	exit 1
fi

# Stampa tutti i numeri da 1 al numero inserito come argomento, specificando se sono pari o dispari
for (( i=1; i<=$1; i++ )) ; do 
	even_odd "$i"
done 

