# Genera el listado de urls para descargar los ficheros automaticamente mediante wget
cd temp

if [ -f urls ]
then
        rm urls
fi

for num in `seq 2006 2008`
do
        echo http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/${num}/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre}_${num}.zip | tr ' ' '\n' >> aurls
done

# Excepcion 2009
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2009/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre}%202009.zip"\n">>aurls
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2009/Diciembre_2009.zip>>aurls

for num in `seq 2010 2014`
do
        echo http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/${num}/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre}_${num}.zip | tr ' ' '\n'>>aurls
done

# Excepcion 2015
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2015/{Enero,Febrero,Marzo,Abril}_2015.zip"\n">>aurls

# Se eliminan espacios a izquierda y a derecha y lineas vacias
sed 's/^ *//; s/ *$//; /^$/d' aurls > urls
rm aurls

cd ..
