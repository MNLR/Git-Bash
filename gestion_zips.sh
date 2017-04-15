# Descomprime, extrae y escribe la informacion contenida en los zip descargados en forma de serie temporal.
# Extrae la tabla 127P de cada archivo .zip (ya ordenados previamente), la procesa y envia cada dato al
# correspondiente directorio.
# Parametros de entrada:
# $1: Directorio de instalacion
# $2: Nivel de informacion
# $3: 1 si la instalacion se quedo en este paso
#     0 si no

DIR=$1
INF=$2
INCOMPLETA=$3

if [ $INF == 1 ] || [ $INF == 0 ]
then
        opcion=-qq
else
        opcion=
fi

if [ $INCOMPLETA == 1 ]
then
        CONTINUAREN=$( tail -1 $DIR/.progreso | cut -d"_" -f 2 )
	CONTINUAREN=$(( CONTINUAREN + 1 ))
else
	CONTINUAREN=1
	mkdir temp/zips/extr
fi


#Nombres para los archivos de texto de las series
tipo[1]="Nuclear.txt"
tipo[2]="Carbones.txt"
tipo[3]="Lignitos.txt"
tipo[4]="Fuel.txt"
tipo[5]="GasNatural.txt"
tipo[6]="Otros.txt"
tipo[7]="Total.txt"

ppal=$PWD

# Generamos un fichero con las fechas para las series temporales (columna) y se ordena
echo {2006..2015}0{1..9} | fold -s | fold -s -w6 | sed '/^\s*$/d' > temp/zips/auxtiempo
echo {2006..2015}{10..12} | fold -s | fold -s -w6 | sed '/^\s*$/d' >> temp/zips/auxtiempo
sort temp/zips/auxtiempo > temp/zips/tiempo
rm temp/zips/auxtiempo

cont_temporal=1

cd temp/zips
# Extraccion y procesado
espacio=" "
sumar=1
for zip in *.zip
do
	#echo "ESTE ES cont_temporal: $cont_temporal"

        if (( $cont_temporal == $CONTINUAREN )) && (( $INCOMPLETA == 1 ))  # Si se interrumpio el proceso debe borrarse la ultima linea del ultimo zip que se quedo a medias, por seguridad
	then
		if [ $INF == 1 ] || [ $INF == 2 ]
		then
        		echo " -----> Se estan corrigiendo las series temporales "
		fi

		dato_temporal=$(sed "${cont_temporal}q;d" tiempo)
		while read provincia; do
			for txt in $provincia/*txt; do
				[[ -f $txt ]] || continue #Comprueba que haya archivos
				ultimo=$(tail -1 $txt | cut -d" " -f1)
				if [ "$ultimo" == "$dato_temporal" ] ; then
					if [ $INF == 2 ]
                			then
                		        	echo " Se esta rectificando $txt "
			                fi
					sed -i '$ d' $txt # Borrar la ultima linea. Requiere sed version 3.95 o superior
				fi
			done
        	done <$ppal/temp/dirs
		rm extr/*127P*
	fi
	if (( $cont_temporal >= $CONTINUAREN ))
	then
		# Extraccion datos
		if [ $INF == 0 ] || [ $INF == 1 ]; then
			unzip -j $opcion -d extr $zip *127P* 2>/dev/null
		else
			unzip -j $opcion -d extr $zip *127P*
		fi
		if [ $INF == 1 ] || [ $INF == 2 ]; then
			printf "Se esta procesando "
			ls extr/*txt
			printf "\n"
		fi

		# CREACION SERIES TEMPORALES
		# Preproceso del fichero de datos
		sed 's/ //' extr/*127P* | sed -e 's/ //' > extr/aux # se elimina el primer espacio, de los nombres, para seleccionar correctamente columnas
		sed -n -e '/-/,$p' extr/aux | tail -n +2  | sed '/-/q' | head -n -1 | tr -s " " | cut -d" " -f2- > extr/procesado

		# Extraccion datos
		cont=1
		while read provincia; do
			# Para cada provincia:
			sed "${cont}q;d" extr/procesado > extr/linea  # Cada linea corresponde a una provincia
			dato_temporal=$(sed "${cont_temporal}q;d" tiempo)  # Anadimos tiempo

			# Cada columna corresponde a un tipo de combustible:
			# Juntamos tiempo y cantidad de combustible:
			for num in `seq 1 7`  # Separamos cada columna (campo) de la fila aux3
			do
				dato[$num]=$(cut -d' ' -f"$num" extr/linea | sed 's/\.//g' )
				dato_completo=$dato_temporal$espacio${dato[$num]}
				echo $dato_completo >> $provincia/${tipo[$num]}
				if [ $INF == 2 ]
        			then
					printf "  Escribiendo $dato_completo en $provincia/${tipo[$num]} \n"
				fi
			done

			cont=$((cont + sumar))
		done <$ppal/temp/dirs

		echo "3_$cont_temporal" >> $DIR/.progreso
		rm extr/*127P*
	fi
	cont_temporal=$((cont_temporal + sumar))
done
