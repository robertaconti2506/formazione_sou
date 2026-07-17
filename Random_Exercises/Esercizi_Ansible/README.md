## Ansible Vault
Creare un Vault contenente alcune variabili nel formato "var_name: value". Includere tali variabili in un playbook tramite la direttiva "vars_files" e stamparne a video il valore (HINT: ricordarsi di attivare il prompt della password del Vault quando si lancia il playbook).

Ansible Vault fornisce una soluzione per criptare dati sensibili.
Il principio è quello di crittografare una variabile o un intero file, Ansible sarà poi in graado di decifrare questo file durante l'esecuzione recuperando la chiave di crittografia (per esempio dal file /etc/ansible/ansible.cfg).

```bash
# Per creare il Vault
ansible-vault create vars_vault.yml

# Per visualizzare il contenuto di vars_vault.yml
ansible-vault view vars_vault.yml

# Per decrittare il file crittato:
ansible-vault decrypt vars_vault.yml 

# Per crittare il file in chiaro: 
ansible-vault encrypt vars_vault.yml 

# Per eseguire il playbook con il Vault:
ansible-playbook playbook.yml --ask-vault-pass
```

Per evitare di dover inserire la password ogni volta, si può salvare la password in un file di testo assegnandogli come permesso "600" (`chmod 600 vars_vault.txt`), eseguire poi: 
```bash
ansible-playbook playbook.yml --vault-password-file=vars_vault_pass.txt
```

In particolare, in questo esercizio, ho deciso di creare un dizionario contenente le password degli utenti. Le variabili definite nel Vault verranno poi caricate nel playbook tramite  `vars_files`. La variabile `password_utenti`, che contiene un dizionario formato da coppie key-value,  viene poi convertita in una lista iterabile utilizzando il filtro Jinja2 `dict2items`.  

## Liste e Dictionaries 
Creare un playbook Ansible che installi/disinstalli una lista di pacchetti in base a quanto definito in un apposito dictionary.
Creare un playbook Ansible che crei una lista di utenti usando le specifiche contenute in una lista di dictionary (ad esempio gruppo, home directory, shell, etc…).

`playbook1.yml`mostra come installare o rimuovere una lista di pacchetti utilizzando il modulo, indipendente dalla distribuzione, `ansible.builtin.package` (questo modulo non supporta `update_cache`, se è necessario aggiornare la cache dei pacchetti, si può utilizzare un altro modulo in base alla distribuzione della macchina e aggiungere il parametro `update_cache: true`).
I pacchetti sono definiti nella variabile `pacchetti`e ad ogni pacchetto è associato uno stato (present o absent) in base al quale il pacchetto viene installato (present) o disinstallato (absent).
Il filtro Jinja2 `dict2items` converte il dizionario in una lista di coppie chiave-valore, permettendo al task di iterare sugli elementi tramite `loop`.
Per eseguire il playbook: 
```bash
ansible-playbook -i inventory.ini playbook1.yml
```

`playbook2.yml` mostra come creare una lista di utenti utilizzando il modulo `ansible.builtin.user`.
Gli utenti sono definiti nella variabile `users`, una lista di dizionari in cui ogni elemento (utente) contiene le informazioni necessarie per la creazione dell'utente nel sistema. È possibile anche specificare una home directory tramite il parametro `home`. 
Il task itera su tutti gli elementi tramite `loop`. Durante ogni iterazione, la variabile `item`rappresenta il dizionario dell'utente corrente e permette di accedere ai singoli valori tramite le sue chiavi (`.nome`, `.gruppo`, `.shell`, `.home`, se viene aggiunto il parametro).
Il parametro `state: present`indica che l'utente deve essere presente nel sistema, quindi viene creato se non è già presente.
Grazie alla "lista di dizionari" è più facile aggiungere un nuovo utente in caso di necessità, basterà aggiungerlo dopo gli altri.
Per eseguire il playbook: 
```bash
ansible-playbook -i inventory.ini playbook2.yml
```

## Jinja Templates
Creare un playbook Ansible che aggiunga in append sul file /etc/security/limits.conf alcuni settings per un’utente. In ambiente di produzione dobbiamo imporre un numero massimo di file aperti pari a 10000, mentre in ambiente di collaudo e sviluppo 1000.
Supponiamo che in /etc/security/access.conf ci sia un’ultima riga che impedisce l’accesso agli utenti non esplicitamente autorizzati (“- : ALL : ALL”). Creare un playbook Ansible che aggiunga una lista di utenti in whitelist anteponendosi a tale riga (hint: utilizzare l’opzione insertbefore del modulo blockinfile).

Il `playbook.yml`viene utilizzato per configurare automaticamente i limiti delle risorse degli utenti (`/etc/security/limits.conf`) e una whitelist di accesso (`/etc/security/access.conf`).
La configurazione viene generata dinamicamente utilizzando template Jinja2, permettendo di applicare regole differenti in base all'ambiente dell'utente. 
Nel playbook troviamo: 
- Definizione degli utenti e relativi ambienti con liste (`vars` - `users`) 
- Generazione di un file temporaneo contenente i limiti tramite template Jinja2 (`ansible.builtin.template`)
- Inserimento (in append con il parametro `insertfile`) della configurazione generata in /etc/security/limits.conf (`ansible.builtin.blockinfile`)
- Generazione di una whitelist tramite template (`ansible.builtin.template)
- Inserimento (con parametro `insertbefore`della whitelist in /etc/security/access.conf (`ansible.builtin.blockingile`)
Il template `limits.conf.j2`genera automaticamente, tramite ciclo `for`e costrutto `if` le regole per il limite massimo di file aperti.
Il template `access.conf.j2`genera le regole di whitelist per gli utenti autorizzati tramite ciclo `for`. 
Per eseguire il playbook: 
```bash
ansible-playbook -i inventory.ini playbook.yml
```
--- 
Trovare un possibile utilizzo dei Jinja templates per la parametrizzazione di un Dockerfile.

Questo esercizio mostra un possibile utilizzo del template Jinja2 all'interno di Ansible per generare dei `Dockerfile` parametrizzati, in questo modo si evita di dover scrivere manualmente un Dockerfile per ogni applicazione.
Ogni elemento della lista di immagini Docker presente nel playbook contiene: 
- `name`: nome del servizio
- `image`: immagine docker di partenza 
- `workdir`: directory di lavoro del container
- `file`: file da copiare nell'immagine 
- `port`: porta esposta dal container 
- `command`: comando di avvio del container
Per eseguire il playbook: 
```bash
ansible-playbook -i inventory.ini playbook.yml
```