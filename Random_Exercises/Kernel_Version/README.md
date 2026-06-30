<h1 align="center">Kernel Version</h1>
Trovare il modo (o più modi) per capire se il Kernel attualmente running è il più recente installato sulla macchina. Scrivere uno script che esegua automaticamente il controllo e risponda TRUE/FALSE.<br> <br>
Questo script in Bash verifica se il kernel attualmente in esecuzione è la versione più recente installata sulla macchina, confrontando la versione in uso con quella più recente presente nei pacchetti installati.

- `uname -r` restituisce la versione del kernel attualmente in esecuzione
- `rpm -q kernel` elenca le versioni dei kernel installati (sistemi RPM-based)
- `sort -V` ordina le versioni in modo naturale
- `tail -n1` seleziona la versione più recente (primo nell'output di tail)
- `sed` per avere solo il nome del pacchetto 
