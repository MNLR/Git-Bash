# Crea los directorios y subdirectorios de acuerdo a las reglas en p-ca
# Tambien almacena en un archivo de texto las direcciones de los directorios
# ordenadas de acuerdo a cod_p. Esto permite asignar eficientemente las series temporales
# a los directorios correspondientes

ppal="PETC"
mkdir $ppal

while read c; do
  	mkdir $ppal/$c
done <temp/cod_ccaa

cont=1
sumar=1

if [ -f temp/dirs ]
then
	rm temp/dirs
fi

while read c_p; do
	p=$(echo $c_p | grep -Fof temp/pp)
	ca=$(grep $p p-ca.dat | cut -f 2 | head -1)  # obtenemos la ca, no es match completo.
	ca_completo=$(grep $ca temp/cod_ccaa)
	echo "Este es ca:"
	echo "$ca"
	echo "Este es ca_completo:"
	echo "$ca_completo"

	echo "Este es c_p"
	echo "$c_p"

	# Crea el directorio:
        mkdir $ppal/$ca_completo/$c_p
	# Guarda la direccion:
	echo "$ppal/$ca_completo/$c_p" >> temp/dirs

	cont=$((cont + sumar))
done <temp/cod_pp
