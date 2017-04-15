# Descarga los archivos segun indica el archivo temp/urls y los renombra para descomprimirlos en orden
# Parametros de entrada:
# $1: Directorio de instalacion
# $2: Nivel de informacion
# $3: 1 si la instalacion se quedo en este paso
#     0 si no


set -e # Interrumpe el script si ocurre un error 

DIR=$1
INF=$2
INCOMPLETA=$3
bash gen_urls.sh # Generamos el fichero con las url.

# Primero aseguramos que los archivos se ordenen correctamente
lineas=$(cat temp/urls | wc -l)
base=${#lineas} # numero de cifras que tiene el numero de lineas. Esto evita problemas de tipo 10.zip 9.zip
numero=$((10**base))
progreso=0
sumar=1

if [ $INCOMPLETA == 1 ]
then
	CONTINUAREN=$( tail -1 $DIR/.progreso | cut -d"_" -f 2 )
        numero=$((numero + CONTINUAREN))
	CONTINUAREN=$((CONTINUAREN + sumar))
	tail -n +$CONTINUAREN temp/urls > temp/auxurls
	rm temp/urls
	mv temp/auxurls temp/urls
	progreso=$((CONTINUAREN - sumar))
else
	mkdir temp/zips
fi

while read url; do
	if [ $INF == 0 ] || [ $INF == 1 ]
	then
        	wget --quiet $url -O temp/zips/"$numero".zip    #los archivos se nombran para descomprimirlos en orden
		if [  $INF == 1 ]
		then
			echo "$url"
		fi
	else
		 wget $url -O temp/zips/"$numero".zip
	fi

	numero=$((numero + sumar))
	progreso=$((progreso + sumar))
	echo "1_$progreso" >> $DIR/.progreso
done <temp/urls
