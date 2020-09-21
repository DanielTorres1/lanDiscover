#!/bin/bash
# Author: Daniel Torres
# daniel.torres@owasp.org
OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
RESET='\e[0m'	
RESET='\e[0m'	


################## Config HERE ####################
netA_base="10.X.Y.0/28"; # Solo revisar hasta las redes 10.0.0.0 - 10.30.32.0
netB_base="172.X.Y.0/28"; # Solo revisar hasta las redes 172.16.0.0 - 172.31.32.0
netC_base="192.168.X.0/28";
####################################################


function print_ascii_art {
cat << "EOF"

  _                 _____  _                             
 | |               |  __ \(_)                            
 | |     __ _ _ __ | |  | |_ ___  ___ _____   _____ _ __ 
 | |    / _` | '_ \| |  | | / __|/ __/ _ \ \ / / _ \ '__|
 | |___| (_| | | | | |__| | \__ \ (_| (_) \ V /  __/ |   
 |______\__,_|_| |_|_____/|_|___/\___\___/ \_/ \___|_|   
                                                                                                                 
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

#echo "IP actual = "`ifconfig eth0 | grep -i mask | awk '{print $2}'`

nameserver=`grep --color=never nameserver /etc/resolv.conf | awk '{print $2}' | head -1`

echo -e "Servidor DNS actual:$nameserver" 
echo -e "$OKBLUE ¿Es un servidor de nombres del directorio activo? s/n $RESET" 
read ADserver

#echo -e "Test inicial - Verificando si es el ISP es ENTEL" 
#entel=`fping -a -g 172.16.1.0/29`
#entel=`fping -a -g 10.0.0.0/29 2>/dev/null`
#echo "resultado Inicial: ($entel)"
echo -e "$OKBLUE ¿El ISP es ENTEL? s/n $RESET" 
read entel

echo -e "\t $OKGREEN ESCANEANDO RED CLASE A (10.0.0.0 - 10.30.32.0) $RESET"
if [ $ADserver = "s"  ]; then
	discoverNetA.sh -n $netA_base -o $FILE -d $nameserver&
else
	discoverNetA.sh -n $netA_base -o $FILE &
fi

if [ $entel = "s"  ]; then

#echo "Al parecer es una conexion de ENTEL"
echo "NO escanearemos la red clase B porque ENTEL lo usa."

else
	echo -e "\t $OKGREEN ESCANEANDO RED CLASE B (172.16.0.0 - 172.31.32.0) $RESET"
	if [ $ADserver = "s"  ]; then
		discoverNetB.sh -n $netB_base -o $FILE -d $nameserver&
	else
		discoverNetB.sh -n $netB_base -o $FILE &
	fi
	
fi

echo -e "\t $OKGREEN ESCANEANDO RED CLASE C (192.168.0.0 - 192.168.220.0) $RESET"

	if [ $ADserver = "s"  ]; then
		discoverNetC.sh -n $netC_base -o $FILE -d $nameserver&
	else
		discoverNetC.sh -n $netC_base -o $FILE &
	fi
