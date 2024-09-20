#!/usr/bin/sh
#cd /appl/kbpp01/utils/Menu/doc013031/CERTUS
rm salida_certus_seleccion_ping.txt
#rm pingnok.temp
rm time_*.txt

#----------------------------
#   Rutinas 
#----------------------------
$R=`pwd`
DIA=`date '+%d/%m/20%y'`; HORA=`date '+%H:%M:%S'`
ANO=`date '+20%y'`
MES=`date '+%m'`
Hora=$(date +%r)
SER=`uname -a | awk '{print $2}'`


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


#####-------------------------------
RUTINA_IMPRESION () {

#-------------------------
echo "$var1sa"
#echo "Buenos Dias"
echo "Se Anexa Estatus Diario Certus"
echo "Saludos Cordiales"
echo "                      AdminCRM Estatus Diario"

#-------------------------
echo ""
#titulo="PING SERVIDORES "
echo "#----------------------------------#"
echo "#		PING SERVIDORES 4        #"
echo "#----------------------------------#"
pingnok_mensual.temp
RUTINA_PING () {
echo entra1
read x
cont=0
DIA=`date '+%d/%m/20%y'`; HORA=`date '+%H:%M:%S'`
#$CER1
/usr/sbin/ping $servidor -n 6 > time_"$servidor".txt
valor1=`cat time_"$servidor".txt | grep loss | awk {'print $7}'`
echo muestro ping
cat time_"$servidor".txt
read
#        for linea in $(cat time_"$servidor".txt)
#         done
          valor1=`cat time_"$servidor".txt | awk '{print $7}'`
echo Valor1
echo $valor1
read
          if [ "$valor1" = "0%" ]; then
              echo "Tiempo de Respuesta Servidor " $servidor "OK"
              else
              echo "Tiempo de Respuesta Servidor " $servidor "NOT OK"
              cp time_"$servidor".txt NOTOK_time_"$servidor".txt
          fi
}
#$CER1
read x
for servidor in $(cat Matriz_Servidor_certus.txt)
    do
        RUTINA_PING $servidor
        RUTINA_PING $servidor  >> salida_certus_seleccion_ping.txt
    done
###rm time_*.txt

grep "NOT OK" salida_certus_seleccion_ping.txt  > pingnok.temp
cat pingnok.temp > pingnok_mensual.temp
cont1=`cat pingnok.temp | wc -l`
#echo "$cont1 "
if  [ $cont1 -gt 0 ];    #si es mayor que
    then
       echo "#####                               #####                              ##### "
       echo "#####      ATENCION:  Se debe chequear ya que existe Servidores Caidos ##### "
       cat pingnok.temp
       cat pingnok_mensual.temp  | xargs -n1 -i sh -c 'echo `date +%Y-%m-%d\ %H-%M-%S`" {}"'  >> muestra_salida_historico_ping_certus_mensual.txt
#       mailx -s "EXISTEN SERVIDORES CAIDOS EN CERTUS $DIA "  alejo24175@gmail.com fritne23@gmail.com < pingnok.temp
       mailx -s "EXISTEN SERVIDORES CAIDOS EN CERTUS $DIA "  apere7@cantv.com.ve < pingnok.temp 

    else
       echo " "
       echo "  #####      SERVIDORES ACTIVOS  ...   ##### "
fi

#echo " "
#echo " "
#echo "#----------------------------------#"
#echo "#        PING SERVIDORES           #"
#echo "#----------------------------------#"
#DIA=`date '+%d/%m/20%y'`; HORA=`date '+%H:%M:%S'`
#echo "$DIA "

}

clear
#echo "===================================="
#echo " IMPRESION                          "
#echo "===================================="

#RUTINA_MENSAJE  > salida_estatus_crontab_certus.txt 
#RUTINA_MENSAJE
#RUTINA_IMPRESION
echo "En Proceso Gardando en archivo: salida_estatus_crontab_certus.txt Tarda:Aproximadamente 1 Minuto" 
RUTINA_IMPRESION > salida_estatus_crontab_certus.txt
clear
echo "Termine puede revisar la salida "
#mailx -s "CERTUS - Estatus Diario $DIA"  apere7@cantv.com.ve fritne23@gmail.com admcrm@cantv.com.ve < salida_estatus_crontab_certus.txt
mailx -s "CERTUS - Estatus Diario $DIA "  apere7@cantv.com.ve mhenr3@cantv.com.ve < salida_estatus_crontab_certus.txt
