#!/usr/bin/awk -F, -f 

# In input un file .csv e stampa il terzo campo solo se viene matchata la stringa "banana"


# BEGIN, per evitare che il controllo venga ripetuto per ogni riga
BEGIN { 
	if (ARGC !=2) { 
		print "Hai inserito un numero sbagliato di argomenti"
		exit 1 
	} 
} 

# Controllo sul file
BEGINFILE {
    if (ERRNO) {
        print "File non leggibile " ERRNO
        exit 1
    }

    # Controllo estensione .csv
    if (FILENAME !~ /\.csv$/) {
        print "Il file non ha  estensione .csv. Procedo comunque..."
    }
}


# Per ogni riga del file, eseguiamo il ciclo sui campi
{ 
	for (i=1; i<=NF; i++) {
		if ($i == "banana") {
			print $3 
			break 
		} 
	} 
}
