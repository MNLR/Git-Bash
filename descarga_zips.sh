# Descarga los archivos segun indica el archivo temp/urls y los renombra para descomprimirlos en orden

INF=$1

# Primero aseguramos que los archivos se ordenen correctamente
lineas=$(cat temp/urls | wc -l)
base=${#lineas}

numero=10  # Asegura que los nombres esten ordenados

numero=$((10**base))

sumar=1

mkdir temp/zips

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
done <temp/urls
