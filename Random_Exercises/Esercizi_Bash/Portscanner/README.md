<h1 align="center">Portscanner</h1>
Supponiamo di avere 2 VM sul vostro laptop che riescano a "vedersi" lato rete. Scrivere uno script Bash che si comporti come un "port scanner" per capire quali porte TCP sono in ascolto sull'altra VM. E' richiesto di farlo tramite un ciclo che invochi il comando nc (NetCat) e non usando l'apposita feature di tale comando. E' inoltre gradita la customizzazione dell'ip/host target e del range di porte da linea di comando tramite argomenti e relativa sanificazione dell'input.<br><br> 

Questo script utilizza il comando `nc` per verificare quali porte TCP sono in ascolto su un host target, effettuando tentativi di connessione su un intervallo di porte definito dall’utente.

Prima di utilizzarlo è consigliato verificare se la macchina host riesce effettivamente a raggiungere la macchina target. <br>
La macchina target può eseguire:
```bash
nc -l 12345
```
e, successivamente, la macchina host: 
```bash
nc -vz <ip> 12345  
echo $?  
```
se il comando restituisce exit status 0, la porta risulta raggiungibile dalla macchina host. <br><br>
Questo test preliminare serve solo a verificare che esista almeno una comunicazione TCP tra le due macchine su una porta specifica.<br><br>
Eseguire poi lo script <br>
```bash
./portscanner.sh <ip> <porta inizio range> <porta fine range> 
```
per scansionare una sola porta: 
```bash
./portscanner.sh <ip> <numero porta> <numero porta> 
```
In ogni caso, verrà eseguito un `ping` il cui esito però non sarà bloccante. <br> La macchina target potrebbe aver bloccato i pacchetti ICMP (con firewall per esempio), per cui il ping avrà esito negativo nonostante si possa controllare comunque lo stato delle porte. <br> Il ping sarà solo informativo e, ricordiamo che, se la macchina è spenta risulterà comunque "ping fallito" (tutte le porte risulteranno chiuse).<br><br> Nello script sono presenti anche controlli, se l'indirizzo IP inserito non è valido lo script non proseguirà, allo stesso modo, se il range di porte non è valido (numeri interi maggiori di zero, estremo di sinistra minore o uguale dell'estremo di destra).

#### Differenze tra TCP e UDP 
Il TCP, per controllare una porta, instaura una connessione, il client manda un pacchetto SYN e il target risponde con un SYN-ACK. Se invece la porta è chiusa risponde con un pacchetto RST o nessuna risposta nel caso di firewall.<br>
Per quanto riguarda l'UDP probe, la situazione è diversa. Il client invia un pacchetto alla porta UDP, se la porta è chiusa il target risponde con un messaggio di errore (ICMP Port Unreachable), altrimenti non risponde nulla.
L'assenza di risposta, tuttavia, non garantisce che la porta sia aperta, poiché il pacchetto potrebbe essere stato filtrato da un firewall o perso durante la trasmissione.
