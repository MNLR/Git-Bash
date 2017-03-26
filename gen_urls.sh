# Genera el listado de urls para descargar los ficheros automaticamente mediante wget
rm urls

for num in `seq 2006 2008` `seq 2010 2014`
do
        echo http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/${num}/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre}_${num}.zip | tr ' ' '\n' >> urls
done

# Excepciones 2009 2015
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2009/{Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre}%202009.zip"\n">>urls
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2009/Diciembre_2009.zip >> urls
echo -e http://www.minetad.gob.es/energia/balances/Publicaciones/ElectricasMensuales/2015/{Enero,Febrero,Marzo,Abril}_2015.zip"\n">> urls
