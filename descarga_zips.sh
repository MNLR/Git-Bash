# Descarga los archivos segun indica el archivo temp/urls y los renombra para descomprimirlos en orden

numero=1
sumar=1

while read url; do
        wget $url -O temp/"$numero".zip    # ordena los archivos para descomprimirlos en orden
	numero=$((numero + sumar))
done <temp/urls
