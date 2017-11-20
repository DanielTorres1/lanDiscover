#!/bin/bash
# Author: Daniel Torres
# daniel.torres@owasp.org



while getopts ":n:o:" OPTIONS
do
            case $OPTIONS in            
            n)     netA_base=$OPTARG;;            
            o)     FILE=$OPTARG;;            
            ?)     printf "Opcion invalida: -$OPTARG\n" $0
                          exit 2;;
           esac
done

FILE=${FILE:=NULL}
netA_base=${netA_base:=NULL}

if [ $FILE = NULL ] ; then

echo "|              														 			"
echo "| USO: discoverNetA.sh -n 10.0.0.0/24 -o redes.txt]    "
echo "|																		 			"
echo ""
exit
fi


for X in `seq 0 30`;
 do 	
	for Y in `seq 0 32`; # Solo revisar hasta las redes 10.0.0.0 - 10.30.32.0
	do 
		netA=$netA_base
		netA=${netA//X/$X}
		netA=${netA//Y/$Y}
		echo "Escaneando $netA"
		resp_ping=`fping -a -g $netA 2>/dev/null`		
		netA=${netA//\/29/\/24}		
		resp_smb=`nbtscan $netA  | grep ^1 `
		resp_dns=""
		if [ -n "$nameserver" ]; then			 
			resp_dns=`dnsrecon -r $netA| grep --color=never PTR`
		fi
		
		if [ -n "$resp_ping" ] ; then			
			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netA (ping) $RESET"
			echo "$netA" >> $FILE
		fi	
		
		if [ -n "$resp_smb" ] ; then
			
			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netA (smb) $RESET"
			echo "$netA" >> $FILE
		fi			
		
		if [ -n "$resp_dns" ] ; then
			
			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netA (dns) $RESET"
			echo "$netA" >> $FILE
		fi	
	done
	
 done
