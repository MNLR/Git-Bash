#!/bin/bash
#
# main.sh
# Autor: Mikel Néstor Legasa Ríos
#
# Script principal del programa para generar las series temporales de produccion de energia en Espana
# por provincias.
# Ver README adjunto para las opciones en detalle.
# Ejemplo de ejecucion:
# bash main.sh -d ~/midirectorio

#Valores por defecto
DIR=$PWD/PETC
AUT=0
INF=1
BORRAR=1

while getopts d:siIAn option
do
        case "${option}"
        in
                d) DIR=${OPTARG};;
                s) INF=0;;
		i) INF=1;;
                I) INF=2;;
                A) AUT=1;;
		n) BORRAR=0;;
        esac
done

#Comprobaciones iniciales:
bash comprobaciones.sh $DIR $AUT
INCOMPLETA=$(cat temp/inc)
rm temp/inc

if [ $INCOMPLETA == 2 ]; then
	exit
elif [ $INCOMPLETA == 1 ]; then
	PASO=$( tail -1 $DIR/.progreso | cut -d"_" -f 1 )
else
	PASO=1
fi
if (( PASO <= 1)); then
	if [ $INF == 1 ] || [ $INF == 2 ]
	then
		printf "\n -----> 1) Descargando archivos... \n \n"
	fi
	bash descarga_zips.sh $DIR $INF $INCOMPLETA
	echo "2_0" >> $DIR/.progreso
	INCOMPLETA=0
fi
if (( PASO <= 2)); then

	if [ $INF == 1 ] || [ $INF == 2 ]
	then
        	printf "\n -----> 2) Generando estructura de directorios... \n \n"
	fi

	bash gen_codigos.sh $DIR
	bash gen_dirs.sh $DIR $INF
	echo "3_0" >> $DIR/.progreso
        INCOMPLETA=0
fi

if (( PASO <= 3)); then
	if [ $INF == 1 ] || [ $INF == 2 ]
	then
        	printf "\n -----> 3) Desempaquetando archivos y generando series temporales en $DIR... \n \n"
	fi
	bash gestion_zips.sh $DIR $INF $INCOMPLETA
fi
rm $DIR/.progreso  # El proceso ha terminado.

if [ $BORRAR == 1 ]
then
	if [ $INF == 1 ] || [ $INF == 2 ]
	then
        	printf "\n -----> 4) Borrando directorio temp... \n \n"
	fi
	rm -r temp
fi
