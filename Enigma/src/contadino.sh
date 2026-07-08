#!/usr/bin/env bash

STATE_FILE="state/shared_state.env" 

# Carica lo Shared State in memoria
load_state() {
	if [[ ! -f "$STATE_FILE" ]]; then 
		echo "Il file non esiste"
		return 1
	fi 
		
	source "$STATE_FILE"
	
	if [[ -z "$FARMER" || -z "$WOLF" || -z "$SHEEP" || -z "$CABBAGE" ]]; then 
		echo "Stato corrotto o incompleto"
		return 1
	fi 

	return 0
}

# Salva lo stato corrente nello Shared State
save_state() {
cat > "$STATE_FILE" <<EOF
FARMER=$FARMER
WOLF=$WOLF
SHEEP=$SHEEP
CABBAGE=$CABBAGE
EOF
}

# Stampa lo stato attuale
print_state() {
	echo " "
	echo "======================"
	echo "	STATO ATTUALE"
	echo "======================"
	echo "Contadino:	$FARMER"
	echo "Lupo:		$WOLF"
	echo "Pecora:		$SHEEP"
	echo "Cavolo:		$CABBAGE"
	echo "======================"
	echo " "
}

# Controllo se si tratta di uno stato possibile 
is_valid_state() {
	# Lupo solo con pecora
	if [[ "$WOLF" == "$SHEEP" && "$FARMER" != "$WOLF" ]]; then 
		echo "Il lupo mangia la pecora †"
		return 1
	fi

	# Pecora sola con cavolo
	if [[ "$SHEEP" == "$CABBAGE" && "$FARMER" != "$SHEEP" ]]; then 
		echo "La pecora mangia il cavolo †"
		return 1
	fi 

	return 0
}

# Traduzione input
translate_input(){ 
	local input="$1" 

	input="$(echo "$input" | tr 'A-Z' 'a-z')"

	case "$input" in
		contadino) 
			echo "FARMER"
			;;
		lupo) 
			echo "WOLF"
			;;
		pecora) 
			echo "SHEEP"
			;;
		cavolo)
			echo "CABBAGE"
			;;
		*) 
			echo "Elemento non valido"
			return 1 
			;;
	esac
}

# Per aggiornare i processi figli
notify() {
	local target="$1"

    	case "$target" in
		WOLF)
			kill -SIGUSR1 "$WOLF_PID"
			;;
        	SHEEP)
            		kill -SIGUSR1 "$SHEEP_PID"
            		;;
        	CABBAGE)
            		kill -SIGUSR1 "$CABBAGE_PID"
            		;;
    	esac
}

# Stato iniziale 
init_state() {
cat > "$STATE_FILE" <<EOF
FARMER=RIGHT
WOLF=RIGHT
SHEEP=RIGHT
CABBAGE=RIGHT
EOF
}

# Controllo vittoria 
check_win() {
	if [[ "$FARMER" == "LEFT" && "$WOLF" == "LEFT" && "$SHEEP" == "LEFT" && "$CABBAGE" == "LEFT" ]]; then 
		return 0
	else 
		return 1
	fi
}

# Approva input 
move() {
	local item="$1" 
	
	# Se l'output è diverso da 0 
	if ! item=$(translate_input "$item" ); then 
		echo "Mossa non valida" 
		return 1
	fi 
	
	# Verifica che l'elemento si trovi sulla stessa sponda del contadino
	if [[ "${!item}" != "$FARMER" ]]; then
		echo "Non puoi fare questo spostamento, non si trova sulla stessa sponda del contadino" 
		
		return 1
	fi 

	#Il contadino cambia sponda ogni volta che viene chiamata la funzione 
	if [[ "$FARMER" == "LEFT" ]]; then 
		FARMER="RIGHT"
	else 
		FARMER="LEFT" 
	fi 

	# Spostiamo l'elemento scelto dall'utente 
	case "$item" in
		FARMER) 
			# Si sposta sempre con gli altri elementi
			;;

		WOLF) 
			WOLF="$FARMER"
			;;
		SHEEP) 
			SHEEP="$FARMER"
			;;
		CABBAGE) 
			CABBAGE="$FARMER" 
			;; 
	esac 
	
	if ! is_valid_state; then 
		echo "Game over ††"
		return 2
	else
		save_state
		print_state

		notify "$item"

		# Se sono tutti sulla sponda opposta
		if check_win; then
			echo "Enigma completato"
			return 3
		fi
	fi 
	
	return 0
}


echo "Ciao, benvenuto" 
echo "Un contadino, un lupo, una pecora, sono sulla stessa sponda del fiume, il contadino con il suo mezzo deve trasportare dall'altra parte del fiume i tre elementi"
echo "Attenzione, ne può trasportare solo uno alla volta e il lupo non può mai rimanere solo con la pecora, la pecora non può mai rimanere sola con il cavolo" 
echo " "
echo "Iniziamo" 

# Per evitare problemi con path diversi 
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

STATE_FILE="$BASE_DIR/state/shared_state.env"
LOG_FILE="$BASE_DIR/logs/system.log"

init_state
load_state
print_state

# Avvio processi figli
"$BASE_DIR/src/lupo.sh" "$STATE_FILE" "$LOG_FILE" &
WOLF_PID=$!

"$BASE_DIR/src/pecora.sh" "$STATE_FILE" "$LOG_FILE" &
SHEEP_PID=$!

"$BASE_DIR/src/cavolo.sh" "$STATE_FILE" "$LOG_FILE" &
CABBAGE_PID=$!

while true; do 
	read -p "Quale elemento vuoi spostare? " choice 
	
	move "$choice"
	result=$?

	case $result  in 
		0) 
			# ok, può continuare
			;; 
		1) 
			echo "Riprova. Ricorda che puoi trasportare solo: lupo, pecora, cavolo" 
			;;
		2) 
			break 
			;; 
		3) 
			echo "Complimenti" 
			kill -SIGTERM "$WOLF_PID"
			kill -SIGTERM "$SHEEP_PID"
			kill -SIGTERM "$CABBAGE_PID"
			break ;;
	esac
done 
