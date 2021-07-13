#!/bin/bash
# Author: Daniel Torres
# daniel.torres@owasp.org

while getopts ":n:d:o:" OPTIONS
do
            case $OPTIONS in            
            d)     nameserver=$OPTARG;;
            n)     netB_base=$OPTARG;;
            o)     FILE=$OPTARG;;            
            ?)     printf "Opcion invalida: -$OPTARG\n" $0
                          exit 2;;
           esac
done

FILE=${FILE:=NULL}
nameserver=${nameserver:=NULL}
netB_base=${netB_base:=NULL}

if [ $FILE = NULL ] ; then

echo "|              														 			"
echo "| USO: discoverNet.sh -n 10.0.0.0/24 -o redes.txt -d 10.0.0.2]    "
echo "|																		 			"
echo ""
exit
fi



for X in `seq 16 31`;
 do 	
	for Y in `seq 0 32`; # Solo revisar hasta las redes 172.16.0.0 - 172.31.32.0
	do 
		netB=$netB_base
		netB=${netB//X/$X}
		netB=${netB//Y/$Y}
		echo "Escaneando $netB"
		resp_ping=`fping -a -g $netB 2>/dev/null`				
		netB=${netB//\/28/\/24}
		resp_smb=`nbtscan $netB  | grep ^1 `
#		resp_dns=""
		#resp_dns=`dnsrecon -r $netB| grep --color=never PTR`

		if [ -n "$resp_ping" ] ; then			
			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netB (ping) $RESET"
			echo "$netB" >> $FILE
		fi	
		
		if [ -n "$resp_smb" ] ; then			
			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netB (smb) $RESET"
			echo "$netB" >> $FILE
		fi	
		
#		if [ -n "$resp_dns" ] ; then
#			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netB (dns) $RESET"
			#echo "$netB" >> $FILE
		#fi	
	sleep 3
	done
	
 done
