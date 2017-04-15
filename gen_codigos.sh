# Lee y procesa los nombres de comunidad autonoma y provincia automaticamente utilizando w3m anadiendo los
# codigos a cada nombre y eliminando caracteres conflictivos
set -e

cd temp
## Obtencion de los codigos de comunidad autonoma
w3m http://www.ine.es/daco/daco42/codmun/cod_ccaa.htm > cod_ccaa_bruto
linea0=$(cat cod_ccaa_bruto | grep -n "comunidades y ciudades aut" | cut -d ':' -f 1) # Linea en la que empieza
tail -n +$linea0 cod_ccaa_bruto | head -n 22 | grep [0-9] > cod_ccaa_preprocesado # Se toma el fragmento con informacion

# Se eliminan todos los caracteres especiales y se procesa para eliminar
cat cod_ccaa_preprocesado | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/,//g; s/ /_/1; s/ //g; s/-//g'  | sed  -E "s/[[:space:]]+/ /g"  > cod_ccaa

rm cod_ccaa_preprocesado

## Obtencion de los codigos de provincia
w3m http://www.ine.es/daco/daco42/codmun/cod_provincia.htm > cod_pp_bruto
linea0=$(cat cod_pp_bruto | grep -n "provincias con sus" | cut -d ':' -f 1)
tail -n +$linea0 cod_pp_bruto | head -n 22 | grep [0-9] > cod_pp_preprocesado

cat cod_pp_preprocesado | sed 's/á/a/g; s/é/e/g; s/í/i/g; s/ó/o/g; s/ú/u/g; s/ñ/n/g; s/,//g; s/Á/A/g; s/É/E/g ; s/Í/I/g ; s/Ó/O/g ; s/Ú/U/g; s/è/e/g' > cod_pp_procesado
rm cod_pp_bruto
rm cod_pp_preprocesado

# Separamos ordenadamente los codigos y provincias, -o toma solo la coincidencia y no la linea entera
cat cod_pp_procesado | grep -Eo "[0-9]+" > cod_p_n
cat cod_pp_procesado | grep -Eo "[^0-9]+" > cod_p_paux
rm cod_pp_procesado

# Eliminar espacios y barras de los nombres
cat cod_p_paux | cat cod_p_paux |  sed " s/\//_/g; s/ //g" > pp
rm cod_p_paux

# Por ultimo pegamos ambas columnas con una barra baja separandolas
paste --delimiters=_ cod_p_n pp > socod_pp
# Y ordenamos cod_pp por codigo para aprovechar la estructura en los zip
sort socod_pp > cod_pp
rm socod_pp

rm cod_p_n # NO se borran los nombres de las provincias pp, se usan despues para vincularlos con la ca
cd ..
