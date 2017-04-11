# Descomprime, extrae y escribe la informacion contenida en los zip descargados en forma de serie temporal.
# Extrae la tabla 127P de cada archivo .zip (ya ordenados previamente), la procesa y envia cada dato al
# correspondiente directorio.

DIR=$1
INF=$2

if [ $INF == 1 ] || [ $INF == 0 ]
then
        opcion=-qq
else
        opcion=
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
cd temp/zips
mkdir extr

# Generamos un fichero con las fechas para las series temporales (columna) y se ordena
echo {2006..2015}0{1..9} | fold -s | fold -s -w6 | sed '/^\s*$/d' > auxtiempo
echo {2006..2015}{10..12} | fold -s | fold -s -w6 | sed '/^\s*$/d' >> auxtiempo
sort auxtiempo > tiempo
rm auxtiempo

cont_temporal=1

# Extraccion y procesado
espacio=" "
for zip in *.zip
do
	# Extraccion datos
	unzip -j $opcion -d extr $zip *127P*
	if [ $INF == 1 ] || [ $INF == 2 ]
	then
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
	sumar=1
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
				printf "  Escribiendo $dato_completo en $provincia/${tipo[$num]}... \n"
			fi
		done

		cont=$((cont + sumar))
	done <$ppal/temp/dirs

	cont_temporal=$((cont_temporal + sumar))
	rm extr/*127P*
done
