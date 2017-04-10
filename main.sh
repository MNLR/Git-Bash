#!/bin/bash
#
# main.sh
# Autor: Mikel Néstor Legasa Ríos
#
# Script principal.
# Ver README adjunto para las opciones en detalle.
# Ejemplo de ejecucion:
# bash main.sh -d ~/midirectorio


DIR=$PWD/PETC
AUT=0
INF=1

while getopts d:siIA option
do
        case "${option}"
        in
                d) DIR=${OPTARG};;
                s) INF=0;;
		i) INF=1;;
                I) INF=2;;
                A) AUT=1;;
        esac
done

#Comprobaciones iniciales:
bash comprobaciones.sh  $DIR $AUT

if [ $INF == 1 ] || [ $INF == 2 ]
then
	printf "\n -----> 1) Descargando archivos... \n \n"
fi

bash gen_urls.sh
bash descarga_zips.sh $INF

if [ $INF == 1 ] || [ $INF == 2 ]
then
        printf "\n -----> 2) Generando estructura de directorios... \n \n"
fi

bash gen_codigos.sh $DIR
bash gen_dirs.sh $DIR $INF

if [ $INF == 1 ] || [ $INF == 2 ]
then
        printf "\n -----> 3) Desempaquetando archivos y generando series temporales... \n \n"
fi
bash gestion_zips.sh $DIR $INF
