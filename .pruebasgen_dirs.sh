ppal="ProdEnergiaTermoelectricaPorCombustible"
mkdir $ppal

while read c; do
        mkdir $ppal/$c
done <cod_ccaa

diractual=$PWD
cd $ppal
cont=1
sumar=1
while read p; do

#ca=$(cat $datadir/p-ca | grep $p | cut -f 2) 
#to 
#ca=$(cat $datadir/p-ca | grep $p | cut -d' ' -f2)


        ca=$(cat $diractual/p-ca | grep $p | cut -d'' -f2)  # obtenemos la ca, no es match completo.
        ca_completo=$(grep "${ca}" $diractual/cod_ccaa)
        echo "Este es ca:"
        echo "$ca"
        echo "Este es ca_completo:"
        echo "$ca_completo"
        cd *${ca_completo}*
        echo "Estamos en:"
        echo $PWD
        #ls
        # paluego crear el directorio mkdir paux=$(sed "${cont}q;d" $diractual/cod_p_p)
        #cd ..
        cont=$((cont + sumar))
done <$diractual/cod_p_p
cd $diractual


while read p; do

        ca=$(cat $diractual/p-ca | grep $p | cut -f 2)
	echo $ca
        cd *${ca}*
        echo "Whe are:"
        echo $PWD
 	cd ..
        cont=$((cont + sumar))
done <$diractual/cod_p_p
