<h1 align="center">Analizza metriche</h1>
Questo script prende in input un file contenente due colonne separate da uno spazio, la prima contiene il nome dei server e la seconda la relativa percentuale di utilizzo della CPU, calcola poi la media di utilizzo di CPU di ogni server.<br> <br>
Più dettagliatamente: 

```bash
#!/usr/bin/env bash
```
Shebang, comunica al sistema operativo quale interprete utilizzare (in questo caso bash) 
```bash
declare -A counter_server
declare -A somma_cpu
```
Dichiarazione dei due array associativi (`-A`), uno sarà "counter_server" che memorizzerà quante volte è ripetuto uno stesso server, l'altro "somma_cpu" che memorizzerà la somma delle percentuali di utilizzo di CPU di ogni server
```bash
read -p "Inserisci un file: " file
```
Viene stampato a video "Inserisci un file: ", dopo aver inserito da tastiera il nome del file, viene assegnato alla variabile "file"
```bash
 if [[ ! -f "$file" ]]; then
    echo "Il file non esiste"
    exit 1 
fi
```
Costrutto `if` per verificare che il file inserito sia effettivamente un file (`-f`), utilizzo delle doppie parentesi quadre in sostituzione del comando "test", nel caso non fosse un file (quindi nel caso venisse verificato ciò che è tra le parentesi), verrebbe stampato a video "Il file non esiste" e successivamente interrotta l'esecuzione dello script (`exit`)
```bash
 while read -r server percentuale ; do
    (( somma_cpu[$server] += percentuale ))
    (( counter_server[$server]++ ))
done < $file
```
Costrutto `while`: legge riga per riga il file tramite il comando "`read`" (`-r`, evita che vengano interpretati alcuni caratteri), ogni riga viene suddivisa in due parti, la prima colonna sarà assegnata alla variabile "server" mentre la seconda, alla variabile "percentuale".<br>
All'interno del ciclo, ad ogni iterazione, vengono aggiornati i due array associativi, "somma_cpu" memorizza la somma di tutte le percentuali di CPU per lo stesso server, mentre "counter_server" incrementa di uno.<br>
Nella riga finale troviamo il reindirizzamento `<`, indica che il ciclo while leggerà i dati dal file dato in input all'inizio dell'esecuzione.
```bash
echo
echo "=== REPORT UTILIZZO MEDIO CPU ==="
echo
```
Con queste tre righe viene stampata una riga vuota, una riga contenente il messaggio tra virgolette e successivamente un'altra riga vuota 
```bash
for server in "${!somma_cpu[@]}" ; do # restituisce tutte le chiavi dell'array (!)
    media=$((somma_cpu[$server]/counter_server[$server]))
    echo "$server: $media%"
    echo
done
```
Questo ciclo `for`: per ogni chiave dell'array (restituite da `${!somma_cpu[@]}`), calcola la media associata a quella chiave (quindi a quel server) come rapporto tra l'utilizzo totale e il numero di ripetizioni di quel server.<br>
Al passaggio successivo stampa "nome del server: percentuale di utilizzo della CPU".
Stampa una riga vuota.
`done`, chiusura del ciclo iterativo.

<br><br>
Lo script "generatore_log.sh", una volta eseguito, genera il file "metriche.txt" necessario per il file "analizza_metriche.sh". <br> Nella repository sono già presenti tutti e tre i file. <br> 
```bash
./analizza_metriche.sh
```
Output atteso:
```bash
=== REPORT UTILIZZO MEDIO CPU ===

srv-web01: 59%

srv-auth01: 53%

srv-db02: 46%

srv-cache03: 56%
```
