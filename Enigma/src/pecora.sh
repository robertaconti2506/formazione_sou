#!/usr/bin/env bash 

STATE_FILE="$1" 
LOG_FILE="$2" 

# Controllo Shared State
validate_state() {

	if [[ ! -f "$STATE_FILE" ]]; then
		echo "[PECORA] Errore: Shared State non trovato" >> "$LOG_FILE"
		return 1
	fi

	if ! source "$STATE_FILE"; then
		echo "[PECORA] Errore caricamento Shared State" >> "$LOG_FILE"
		return 1
	fi

	if [[ -z "$SHEEP" ]]; then 
		echo "[PECORA] Errore: Shared State corrotto" >> "$LOG_FILE" 
		return 1
	fi 
	
	return 0 
 }


# Legge lo Shared State e registra la posizione del lupo
receive_update() {

	if ! validate_state; then 
		return 1
	fi

	echo "[PECORA] Ricevuto SIGUSR1 - Posizione attuale: $SHEEP" >> "$LOG_FILE"
}

ord_exit() { 
	echo "[PECORA] Ricevuto SIGTERM = Terminazione del processo" >> "$LOG_FILE"
	exit 0
}


# Associazione dei segnali 
trap receive_update SIGUSR1 
trap ord_exit SIGTERM 

echo "[PECORA] Processo avviato (PID $$)" >> "$LOG_FILE"


# Il processo rimane in attesa di segnali 
while true; do 
	sleep 1
done
