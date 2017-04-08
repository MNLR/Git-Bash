# Descarga los archivos segun indica el archivo temp/urls y los renombra para descomprimirlos en orden


# Primero aseguramos que los archivos se ordenen correctamente
lineas=$(cat temp/urls | wc -l)
base=${#lineas}

numero=10  # Asegura que los nombres esten ordenados

numero=$((10**base))

sumar=1

if [ -f temp/zips ]
then
        rm temp/zips
fi

mkdir temp/zips

while read url; do
        wget $url -O temp/zips/"$numero".zip    # ordena los archivos para descomprimirlos en orden
	numero=$((numero + sumar))
done <temp/urls
