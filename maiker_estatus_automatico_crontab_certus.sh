#!/usr/bin/sh
# - - - - - - - - - - - - - - - - - - - - - 
# INICIOS DE SUBRUTINAS DEL SHELL
# - - - - - - - - - - - - - - - - - - - - -

RUTINA_PING () {
       DIA=`date '+%d/%m/20%y'`; HORA=`date '+%H:%M:%S'`
       /usr/sbin/ping $servidor -n 6 > time_"$servidor".txt
       valor1=`cat time_"$servidor".txt | grep loss | awk {'print $7}'`
       if [ "$valor1" = "0%" ]; then
#        if [ "$valor1" ! "100%" ]; then
#       if [ "$valor1" != "100%" ] && [ "$valor1" != "16%" ]; then
#       if [ "$valor1" != "100%" -o "$valor1" != "16%" ]; then  
          echo "Tiempo de Respuesta Servidor " $servidor "OK"
       else
          echo "Tiempo de Respuesta Servidor " $servidor "NOT OK"
#         cp time_"$servidor".txt NOTOK_time_"$servidor".txt
       fi
}

RUTINA_MENSAJE () {
    echo " "
    echo " "
    echo ""
    echo " Administracion de Plataformas Integradas                                                                      " #Ruta :   $R "
    echo " Gerencia Sistema de Gestion Empresarial                                                                         Fecha :   $DIA "
    echo " Gerencia de Ingenieria, desarrollo y Construccion TI/SI                                                         Hora  :   $Hora "
    echo " Gerencia General de Tecnologia y Operaciones                                                                    Servidor: $SER "
    echo ""
    echo "                                                         ===================================="
    echo "                                                                ESTATUS DIARIO CERTUS        "
    echo "                                                         ===================================="
}

RUTINA_IMPRESION () {

#-------------------------

echo "$var1sa"
echo "Se Anexa Estatus Diario Certus"
echo "Saludos Cordiales"
echo "                      AdminCRM Estatus Diario"

echo ""
echo "#-------------------------------------------"
echo "#    20 PING DE SERVIDORES CERTUS - ZIMBRA  " 
echo "#-------------------------------------------"

grep "NOT OK" salida_certus_seleccion_ping.txt  > pingnok.temp
cat pingnok.temp > pingnok_mensual.temp
cont1=`cat pingnok.temp | wc -l`
if  [ $cont1 -gt 0 ];    #si es mayor que
    then
       echo "*****                               *****                              ***** " 
       echo "*****      ATENCION:  Se debe chequear ya que existe Servidores Caidos ***** " 
       echo "*****                               *****                              ***** "   
       cat pingnok.temp
       cat pingnok_mensual.temp  | xargs -n1 -i sh -c 'echo `date +%Y-%m-%d\ %H-%M-%S`" {}"'  >> muestra_salida_historico_ping_certus_mensual.txt
#       mailx -s "EXISTEN SERVIDORES CAIDOS EN CERTUS $DIA "  alejo24175@gmail.com fritne23@gmail.com < pingnok.temp
       mailx -s "EXISTEN SERVIDORES CAIDOS EN CERTUS $DIA "  apere7@cantv.com.ve < pingnok.temp

    else
       echo "*****                               *****                              ***** "
       echo "*****      :) :) :) :)        SERVIDORES ACTIVOS  ...                  ***** "
       echo "*****                               *****                              ***** "
fi

}


# - - - - - - - - - - - - - - - - - - 
# INCIO DE SHELL
# - - - - - - - - - - - - - - - - - -

clear
# - - - - - - - - - - - - - - - - - -
echo " En Proceso "
# - - - - - - - - - - - - - - - - - -
test -f salida_certus_seleccion_ping.txt
if [ $? = 0 ]; then
   rm salida_certus_seleccion_ping.txt
fi
test -f rm time_*.txt
if [ $? = 0 ]; then
   rm time_*.txt
fi

for servidor in $(cat Matriz_Servidor_certus.txt)
    do
#        RUTINA_PING $servidor
        RUTINA_PING $servidor  >> salida_certus_seleccion_ping.txt
    done

R=`pwd`
DIA=`date '+%d/%m/20%y'`; HORA=`date '+%H:%M:%S'`
ANO=`date '+20%y'`
MES=`date '+%m'`
Hora=$(date +%r)
SER=`uname -a | awk '{print $2}'`



#---------------------
# Saludos segun hora #
#---------------------
hora=`date +%R | cut -d ':' -f 1`
if [ $hora -ge 1 -a $hora -lt 12 ]       
    then
       var1sa="Buenos Dias"
    elif [ $hora -ge 12 -a $hora -lt 18 ]     
         then
       var1sa="Buenas Tardes"
    else
       var1sa="Buenas Noches"
fi




echo "En Proceso Gardando en archivo: salida_estatus_crontab_certus.txt Tarda:Aproximadamente 1 Minuto" 
RUTINA_IMPRESION > salida_estatus_crontab_certus.txt
echo "Termine puede revisar la salida "
#mailx -s "CERTUS - Estatus Diario $DIA"  apere7@cantv.com.ve fritne23@gmail.com admcrm@cantv.com.ve < salida_estatus_crontab_certus.txt
mailx -s "CERTUS - Estatus Diario $DIA "  apere7@cantv.com.ve mhenr3@cantv.com.ve < salida_estatus_crontab_certus.txt
