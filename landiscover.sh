#!/bin/bash
# Author: Daniel Torres
# daniel.torres@owasp.org
OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
RESET='\e[0m'	
RESET='\e[0m'	


################## Config HERE ####################
netA_base="10.X.Y.0/29"; # Solo revisar hasta las redes 10.0.0.0 - 10.30.32.0
netB_base="172.X.Y.0/29"; # Solo revisar hasta las redes 172.16.0.0 - 172.31.32.0
netC_base="192.168.X.0/29";
####################################################


function print_ascii_art {
cat << "EOF"

					daniel.torres@owasp.org
					https://github.com/DanielTorres1

EOF
}

print_ascii_art

while getopts ":o:" OPTIONS
do
            case $OPTIONS in            
            o)     FILE=$OPTARG;;            
            ?)     printf "Opcion invalida: -$OPTARG\n" $0
                          exit 2;;
           esac
done

FILE=${FILE:=NULL}

if [ $FILE = NULL ] ; then

echo "|              														 			"
echo "| USO: landiscover.sh -o redes.txt]    "
echo "|																		 			"
echo ""
exit
fi

echo "IP = "`ifconfig eth0 | grep -i mask | awk '{print $2}'`


echo -e "$OKBLUE IP del servidor de nombres local  $RESET" 
read nameserver

echo -e "$OKBLUE Test inicial $RESET" 
fping -a -g 172.16.1.0/29

echo -e "$OKBLUE Es un enlace de ENTEL?? s/n $RESET" 
read entel

if [ -n "$nameserver" ]; then
    echo "nameserver $nameserver" > /etc/resolv.conf          
fi
  

echo -e "\t $OKGREEN ESCANEANDO RED CLASE A $RESET"
if [ -n "$nameserver" ]; then
	discoverNetA.sh -n $netA_base -o $FILE -d $nameserver&
else
	discoverNetA.sh -n $netA_base -o $FILE &
fi

if [ $entel = "s" ] ; then

echo "NO escanearemos la red clase B"
echo "ENTEL usa este segmento :("
else
	echo -e "\t $OKGREEN ESCANEANDO RED CLASE B $RESET"
	if [ -n "$nameserver" ]; then
		discoverNetB.sh -n $netB_base -o $FILE -d $nameserver&
	else
		discoverNetB.sh -n $netB_base -o $FILE &
	fi
	
fi

echo -e "\t $OKGREEN ESCANEANDO RED CLASE C $RESET"

	if [ -n "$nameserver" ]; then
		discoverNetC.sh -n $netC_base -o $FILE -d $nameserver&
	else
		discoverNetC.sh -n $netC_base -o $FILE &
	fi
