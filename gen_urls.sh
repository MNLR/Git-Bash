# Genera el listado de urls para descargar los ficheros automaticamente mediante wget
cd temp
rm urls

for num in `seq 2006 2008`
do
        echo http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/${num}/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre}_${num}.zip | tr ' ' '\n' >> urls
done

# Excepcion 2009
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2009/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre}%202009.zip"\n">>urls
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2009/Diciembre_2009.zip>>urls

for num in `seq 2010 2014`
do
        echo http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/${num}/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre}_${num}.zip | tr ' ' '\n'>>urls
done

# Excepcion 2015
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2015/{Enero,Febrero,Marzo,Abril}_2015.zip"\n">>urls


cd ..
