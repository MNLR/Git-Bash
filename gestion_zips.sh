# Descomprime, extrae y escribe la informacion contenida en los zip descargados.

cd temp

for zip in *zip
do
	unzip -j 1112.zip *127P*
	
	# sacar datos y meter en los directorios
	rm *127P*
done

unzip -j 1112.zip *127P* -d cosa


#sort cod_pp # ordena las provincias por codigo. Esto aprovecha la estructura la tabla dentro de los zips
#awk -F" " '{print $2 " " $3}' aux




# recorrer en orden los zips-

