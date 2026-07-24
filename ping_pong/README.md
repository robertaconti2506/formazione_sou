# <h1 align="center">Ping Pong </h1>
## Descrizione progetto 
Questo progetto implementa un ambiente composto da due nodi Linux (due VM Ubuntu), configurati tramite Vagrant e gestiti attraverso Ansible.

L'obiettivo del progetto è realizzare una soluzione automatizzata in grado di gestire la presenza di un container Docker su due nodi Linux, garantendo che il servizio sia attivo su un solo nodo alla volta. Il container utilizzato è `ealen/echo-server` e viene eseguito alternativamente su `node1` e `node2` con una migrazione automatizzata ogni 60 secondi.

Automazione e orchestrazione:
- Vagrant per la creazione dell'infrastruttura virtuale;
- Ansible per la configurazione dei nodi e la gestione del container;
- Docker per l'esecuzione del servizio;
- Cron come scheduler per l'esecuzione periodica della migrazione.

La migrazione non rappresenta uno spostamento fisico del container, ma una simulazione tramite ricreazione del container sul nodo di destinazione e rimozione dal nodo sorgente.

## Architettura
L'architettura del progetto è composta da due nodi Linux virtualizzati (`node1` e `node2`) creati tramite Vagrant e configurati tramite Ansible.
Il nodo orchestratore è l'host locale, che gestisce il ciclo di vita dell'ambiente e pianifica le operazioni di migrazione tramite Cron.

Il flusso operativo è il seguente:
1. **Creazione dell'infrastruttura**
   - Vagrant crea le due macchine virtuali Linux (Ubuntu).
   - Ogni nodo viene configurato con rete privata e accesso SSH per Ansible.

2. **Provisioning dei nodi**
   - Ansible installa Docker su entrambi i nodi.
   - Viene scaricata l'immagine Docker `ealen/echo-server`.
   - Il container viene avviato inizialmente sul nodo `node1`.
   - Il nodo `node2` viene mantenuto senza il container.

3. **Scheduler della migrazione**
   - Lo scheduler viene configurato sull'host orchestratore tramite `scheduler.yml`.
   - Un job Cron esegue automaticamente `migrate.yml` ogni 60 secondi.

4. **Migrazione del container**
   - `migrate.yml` verifica su quale nodo è presente il container.
   - Il container viene fermato e rimosso dal nodo corrente.
   - Lo stesso container viene avviato sull'altro nodo.
   - Al termine della procedura il servizio risulta attivo su un solo nodo.

## Prerequisiti 
- Vagrant 
- VirtualBox
- Ansible 
- Python 3 
## Avvio del progetto 
Clonare il repository e accedere alla directory del progetto:
```bash
git clone https://github.com/robertaconti2506/formazione_sou.git
cd formazione_sou/ping_pong
```
Avviare il progetto: 
```bash
vagrant up 
```
Per accedere alle VM (`node1`e `node2`):
```bash
vagrant ssh node1
vagrant ssh node2
```
Dopo aver configurato l'ambiente sull'host orchestratore, attivare lo scheduler sull'host orchestratore:
```bash
ansible-playbook -i inventory.ini scheduler.yml
```
Lo scheduler configura un job Cron che esegue automaticamente il playbook di migrazione ogni 60 secondi.

## Verifica del funzionamento
Per verificare su quale nodo è attivo il container:
```bash
vagrant ssh node1
docker ps
```
se presente sul `node1`, aspettare poco più di un minuto e provare con:
```bash
vagrant ssh node2
docker ps
```
Il container dovrebbe risultare una volta su un nodo e la successiva sull'altro.