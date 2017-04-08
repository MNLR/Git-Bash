# Lee y procesa los nombres de comunidad autonoma y provincia utilizando w3m anadiendo los codigos a cada nombre

cd temp
# Obtencion de los codigos de comunidad autonoma
w3m http://www.ine.es/daco/daco42/codmun/cod_ccaa.htm > cod_ccaa_bruto
linea0=$(cat cod_ccaa_bruto | grep -n "comunidades y ciudades aut" | cut -d ':' -f 1)
tail -n +$linea0 cod_ccaa_bruto | head -n 22 | grep [0-9] | sed 's/í/i/g' | sed 's/ó/o/g' | sed 's/ñ/n/g' | sed "s/,//g" | sed  -E "s/[[:space:]]+/ /g" > cod_ccaa_aux
rm cod_ccaa_bruto

#cat cod_ccaa | awk '{print $1}' > cod_ccaa_n
#cat cod_ccaa | cut -d' ' -f2-10 | sed 's/ //g' | sed 's/-/_/g' > cod_ccaa_c
#rm cod_ccaa

cat cod_ccaa_aux | sed -e 's/ /_/1' | sed 's/ //g' |  sed 's/-//g' > cod_ccaa
rm cod_ccaa_aux

# sed '2q;d' cod_ccaa_c

# Obtencion de los codigos de provincia
w3m http://www.ine.es/daco/daco42/codmun/cod_provincia.htm > cod_p_bruto
linea0=$(cat cod_p_bruto | grep -n "provincias con sus" | cut -d ':' -f 1)
tail -n +$linea0 cod_p_bruto | head -n 22 | grep [0-9] | sed 's/í/i/g' | sed 's/ó/o/g' | sed 's/ñ/n/g' | sed 's/á/a/g' | sed 's/é/e/g' > cod_p

rm cod_p_bruto

# Separamos ordenadamente los codigos y provincias
cat cod_p | grep -Eo "[0-9]+" > cod_p_n
cat cod_p | grep -Eo "[^0-9]+" > cod_p_paux
rm cod_p

#cat cod_p_paux | sed "s/ /_/g" | sed "s/,/_/g" > cod_p_p
cat cod_p_paux | awk '{print $1 $2 $3 $4}' | sed "s/,/_/g" | sed "s/\//_/g" | sed "s/è/e/g" | sed "s/Á/A/g" > pp
rm cod_p_paux

# Por ultimo pegamos ambas columnas con una barra baja separandolas
paste --delimiters=_ cod_p_n pp > socod_pp
# Y ordenamos cod_pp por codigo para aprovechar la estructura en los zip
sort socod_pp > cod_pp
rm socod_pp

rm cod_p_n # NO se borran los nombres de las provincias, se usan despues
cd ..
