# Descarga los archivos segun indica el archivo temp/urls y los renombra para descomprimirlos en orden
# El parametro de entrada es el nivel de informacion que se dara al usuario
# 0 ninguna informacion
# 1 informacion moderada
# 2 toda la informacion

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
