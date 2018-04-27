# lanDiscover

LansDiscover puede ser utilizada en una red interna para realizar un escaneo primiliar SMB,ICMP,DNS para descubrir subredes utilizadas. Debido al rango de direcciones IP (Clase A,B,C) que escanea, la herramienta tarda bastante.


## ¿COMO INSTALAR?

Testeado en Kali 2:

    git clone https://github.com/DanielTorres1/landiscover
    cd landiscover
    bash instalar.sh


## ¿COMO USAR?
**landiscover.sh**

Opciones: 

    -o : Archivo de salida (Subredes con hosts)


Ejemplo:

    landiscover.sh -o redes.txt
