# Crea los directorios y subdirectorios de acuerdo a las reglas en p-ca
# Tambien almacena en un archivo de texto las direcciones de los directorios
# ordenadas de acuerdo a cod_p. Esto permite asignar eficientemente las series temporales
# a los directorios correspondientes.
# Entrada:
# $1: Directorio de instalacion
# $2: Nivel de informacion

set -e

DIR=$1
INF=$2

if [ $INF == 2 ]
then
	opcion=-v
else
	opcion=
fi

if [ -f temp/dirs ]; then # Debe rehacerse si quedo incompleto para no duplicar rutas
        rm temp/dirs
	rm -r $DIR/*/ # Para evitar errores se eliminan todos los directorios
fi

while read c; do
  	mkdir $opcion $DIR/$c
done <temp/cod_ccaa

cont=1
sumar=1

while read c_p; do
	p=$(echo $c_p | grep -Fof temp/pp)
	ca=$(grep $p p-ca.dat | cut -f 2 | head -1)  # obtenemos la ca, no es match completo.
	ca_completo=$(grep $ca temp/cod_ccaa)

	# Crea el directorio:
        mkdir $opcion $DIR/$ca_completo/$c_p
	# Guarda la direccion del directorio:
	echo "$DIR/$ca_completo/$c_p" >> temp/dirs

	cont=$((cont + sumar))
done <temp/cod_pp
