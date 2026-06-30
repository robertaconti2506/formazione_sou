<h1 align="center">Awk</h1>
Scrivere un programma AWK che prende in input un file .csv e stampa il terzo campo solo se viene matchata la stringa "banana". <br><br>

A differenza degli script bash, la shebang sarà: 
```awk
#!/usr/bin/awk -F, -f 
``` 
- `-F`il separatore dei campi è la `,`
- `-f` le istruzioni e il codice da eseguire devono essere letti dal file di script stesso in cui questa riga è scritta <br>
\* nel caso ci fossero problemi, si potrebbe eliminare `-F`e, successivamente, aggiungere `BEGIN { FS="," }

Per eseguire lo script: 
```bash
./awk.awk <file.csv>
```

Lo stesso output si avrebbe eseguendo, da linea di comando: 
```bash
awk -F, '/banana/ { print $3 }' awk.csv (comando) - pattern: banana
```

Si può testare lo script con il file "fruit.csv" presente nella repository. 
