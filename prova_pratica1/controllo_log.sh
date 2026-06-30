#!/usr/bin/env bash   

read -p "Inserisci il file: " file                     

if [[ -f $file ]] ; then                                 

        file_n=$(sort "$file" | uniq -c | sort -rn | head -n3)  
  
        echo "$file_n"                                  
else                                                     
        echo "Non è un file"                                   
fi    
