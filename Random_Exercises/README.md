# Ipv4 regex

## Classificazione degli indirizzi IP

Distinguiamo prima gli indirizzi IP in indirizzi pubblici, privati o riservati e poi in base al primo ottetto. 

######
|range| tipo|
|-----|-----|
|10.0.0.0 - 10.255.255.255|privato|
|127. * . * . * . *|riservato (loopback)|
|169.254. * . * . *|riservato (APIPA)|
|172.16.0.0 - 172.31.255.255|privato|
|192.168.0.0 - 192.168.255.255|privato|
|0.0.0.0| riservato (jolly)|


###### 
| Primo ottetto | Classe | 
|---------------|--------|
|1-126|classe A|
|128-191*|classe B| 
|192-223|classe C| 
|224-239|classe D|
|240-255|classe E| 

* gli indirizzi IP che appartengono al seguente gruppo, sono gli indirizzi APIPA: 169.254. \* . \* 

Ci sono delle condizioni ripetute due volte, è stato fatto volutamente per distinguere totalmente le due classificazioni.
Ho utilizzato ".+" invece di ripetere gli intervalli numerici perchè il primo if esclude ogni tipo di input diverso dall'indirizzo IPv4.
