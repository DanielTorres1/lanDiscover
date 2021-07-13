#!/bin/bash
# Author: Daniel Torres
# daniel.torres@owasp.org


while getopts ":n:d:o:" OPTIONS
do
            case $OPTIONS in            
            d)     nameserver=$OPTARG;;
            n)     netA_base=$OPTARG;;
            o)     FILE=$OPTARG;;            
            ?)     printf "Opcion invalida: -$OPTARG\n" $0
                          exit 2;;
           esac
done

FILE=${FILE:=NULL}
nameserver=${nameserver:=NULL}
netA_base=${netA_base:=NULL}

if [ $FILE = NULL ] ; then

# # discoverNetC.sh -n 196.168.X.0/28 -o red.txt -d 10.0.0.1
echo "|              														 			"
echo "| USO: discoverNet.sh -n 10.0.0.0/24 -o redes.txt]    "
echo "|																		 			"
echo ""
exit
fi


for X in `seq 0 180`;
 do 	
	for Y in `seq 0 100`; # Solo revisar hasta las redes 10.0.0.0 - 10.100.100.0
	do 
		netA=$netA_base
		netA=${netA//X/$X}
		netA=${netA//Y/$Y}
		echo "Escaneando $netA"
		resp_ping=`fping -a -g $netA 2>/dev/null`		
		netA=${netA//\/28/\/24}		
		resp_smb=`nbtscan $netA  | grep ^1 `
		#resp_dns=""
		#resp_dns=`dnsrecon -r $netA| grep --color=never PTR`
				
		if [ -n "$resp_ping" ] ; then			
			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netA (ping) $RESET"
			echo "$netA" >> $FILE
		fi	
		
		if [ -n "$resp_smb" ] ; then
			
			echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netA (smb) $RESET"
			echo "$netA" >> $FILE
		fi			
		
		#if [ -n "$resp_dns" ] ; then
			
		#	echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netA (dns) $RESET"
			#echo "$netA" >> $FILE
		#fi	
	sleep 5
	done
	
 done
