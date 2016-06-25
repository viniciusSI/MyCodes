#!/bin/bash
###########################################################
#	Script para monitorar portas e protocolos         #
#	      Autor: Vinícius Soares Bento	          #
#		   Data:  24/06/2016        		  #
###########################################################

LOGNAME=logs.txt
IP=10.1.1.10
HOUR="$(date +'%H:%M:%S')"
DATE="$(date +'%d/%m/%y')"

 notificatelegram(){
 TELEGRAMPROGRAM='/usr/bin/telegram-cli'
         DESTINATARIO='Alerta'
		$TELEGRAMPROGRAM -WR  -e "msg $DESTINATARIO $IP - is DOWN ($DATE $HOUR) - Verifique a a internet do servidor"> /dev/null 2>&1 || exit 1 &
}

#Armazena o plugin do nagios de teste icmp na variavel 'checkP'
CHECKP='/usr/lib64/nagios/plugins/check_smtp'

	for ((FALHAS=1;FALHAS<=4;FALHAS++))
            do
                 CHECK=$($CHECKP -H $IP)
                 if [[ "`echo "$CHECK"|cut -d" " -f 1`" = "OK" ]]
                    then
                          echo "$DATE - $HOUR - $IP - OK" >> $LOGNAME;
                          FALHAS=5
                    else
                          echo "$DATE - $HOUR - $IP - FAIL" >> $LOGNAME;
                          if [[ "$FALHAS" = "4" ]]
                           then
								echo "$IP - DOWN"
								notificatelegram 		
						  fi
                fi
        done		
	
	

