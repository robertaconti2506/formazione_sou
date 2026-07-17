#!/usr/bin/env bash 

# Assegnamo alla variabile "current_kernel" la versione del kernel attualmente in esecuzione
current_kernel=$(uname -r)

# Assegnamo alla variabile "kernel_recversion" la versione più recente del kernel
kernel_recversion=$(rpm -q kernel | sort -V | tail -n1 | sed 's/kernel-//')

# Ciclo if, output "TRUE" se la versione in esecuzione è la più recente, altrimenti "FALSE"
if [[ "$current_kernel" == "$kernel_recversion" ]] ; then
        echo "TRUE" 
else
        echo "FALSE" 
fi
