<h1 align="center">Controllo log</h1>
Questo script prende in input un file da tastiera, lo elenca in ordine decrescente e restituisce i primi tre elementi con maggiori ripetizioni e anche il numero delle ripetizioni. <br><br>
Più dettagliatamente: <br>

```bash
#!/usr/bin/env bash  
```
Shebang, comunica al sistema operativo quale interprete utilizzare (in questo caso bash) 

```bash
read -p "Inserisci il file: " file
```
Stampa a video la richiesta tra virgolette e assegna alla variabile "file" l'input dato da tastiera

```bash
if [[ -f $file ]] ; then
    file_n=$(sort "$file" | uniq -c | sort -rn | head -n3)
    echo "$file_n"
else
    echo "Non è un file"
fi
```
Costrutto `if`: verifica "file" sia effettivamente un file (doppia quadra in sostituzione di "test") e che sia regolare, in questo caso procede con la riga successiva, altrimenti (`else`) stampa "Non è un file". <br>
Se la risposta al test è affermativa, viene utilizzata una "command substitution" ( $( ) ) tutto ciò che è tra parentesi viene eseguito come comando e, l'output di tale comando, viene assegnato alla variabile "file_n", all'interno delle parentesi:
- viene letto e ordinato il contenuto del file (`sort "$file"`), ordinamento necessario per far si che il comando "uniq" agisca come necessario per il nostro script
- `|` prende l'output di questo comando e lo passa come input al comando successivo
- `uniq` raggruppa le copie successive adiacenti di una riga, con l'opzione `-c` conta anche quante sono le ripetizioni, se le ripetizioni non fossero adiacenti, non verrebbero considerate come tali
- a questo punto, sort ordina numericamente (`-n`) le righe del file e in ordine decrescente (`-r`) infine, head mostra solo le prime tre righe (`-n3`) 

Si può verificare il corretto funzionamento dello script con il file "accessi.txt" presente nella repository. <br>
Output atteso con questo file: 
```bash
   3 192.168.1.10
   2 10.0.0.5
   2 1.2.3.4
```
