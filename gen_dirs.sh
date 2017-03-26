# Crea los directorios y subdirectorios de acuerdo a las reglas en p-ca

ppal="PETC"
mkdir $ppal

while read c; do
  	mkdir $ppal/$c
done <temp/cod_ccaa

cont=1
sumar=1

while read p; do
	ca=$(grep $p temp/p-ca | cut -f 2 | head -1)  # obtenemos la ca, no es match completo.
	ca_completo=$(grep $ca temp/cod_ccaa)
	echo "Este es ca:"
	echo "$ca"
	echo "Este es ca_completo:"
	echo "$ca_completo"

	cod_pp=$(sed "${cont}q;d" temp/cod_pp) # codigo_provincia. Estan ordenados segun pp
	echo "Este es cod_p"
	echo "$cod_p"
        mkdir $ppal/$ca_completo/$cod_pp

	cont=$((cont + sumar))
done <temp/pp
