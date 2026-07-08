#!/usr/bin/env bash

# Il container viene creato all'avvio ed eliminato automaticamente al termine dell'esecuzione
# Creazione di un volume bind mount tra il computer e il container, in questo modo non vengono persi i log 
docker run --rm -it \
-v "$(pwd)/logs:/enigma/logs" \
enigma-lupo-pecora-cavolo



# Questo script viene eseguito dall'utente per avviare il container
