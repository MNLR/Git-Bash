# Descomprime, extrae y escribe la informacion contenida en los zip descargados.

cd temp
sort cod_pp # ordena las provincias por codigo. Esto aprovecha la estructura la tabla dentro de los zips
awk -F" " '{print $2 " " $3}' aux

# recorrer en orden los zips-

