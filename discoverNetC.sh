#!/bin/bash
# Author: Daniel Torres
# daniel.torres@owasp.org

while getopts ":n:o:" OPTIONS
do
            case $OPTIONS in            
            n)     netC_base=$OPTARG;;            
            o)     FILE=$OPTARG;;            
            ?)     printf "Opcion invalida: -$OPTARG\n" $0
                          exit 2;;
           esac
done

FILE=${FILE:=NULL}
netC_base=${netC_base:=NULL}

if [ $FILE = NULL ] ; then

echo "|              														 			"
echo "| USO: discoverNetB.sh -n 10.0.0.0/24 -o redes.txt]    "
echo "|																		 			"
echo ""
exit
fi

for X in `seq 0 220`;
 do 	
	netC=$netC_base
	netC=${netC//X/$X}		
	echo "Escaneando $netC"
	resp_ping=`fping -a -g $netC 2>/dev/null`				
	netC=${netC//\/29/\/24}
	resp_smb=`nbtscan $netC  | grep ^1 `
	resp_dns=""
	if [ -n "$nameserver" ]; then			 
		resp_dns=`dnsrecon -r $netC| grep --color=never PTR`
	fi

	if [ -n "$resp_ping" ] ; then
		
		echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netC (ping) $RESET"
		echo "$netC" >> $FILE
	fi	
		
	if [ -n "$resp_smb" ] ; then		
		echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netC (smb) $RESET"
		echo "$netC" >> $FILE
	fi	
	
	if [ -n "$resp_dns" ] ; then		
		echo -e "\t [+]$OKBLUE Encontre host vivos en la red $netC (dns) $RESET"
		echo "$netC" >> $FILE
	fi	
			
 done
