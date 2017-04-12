## comprobaciones.sh
## Gestiona el inicio del programa y maneja y comprueba si existe una ejecucion anterior
## Genera el archivo inc, que informa de como debe continuar la ejecucion:
##	1: INCOMPLETA
##	0: COMPLETA
##	2: CANCELAR EJECUCION
##
## Recibe $1, el directorio principal
## 	  $2, variable de ejecucion automatica


DIR=$1
AUT=$2
INCOMPLETA=0

if [ $AUT != 1 ]
then
	read -p "Se escribiran las series temporales en $DIR. Introduzca s para continuar: " resp
	if [ "$resp" != "s" ]
	then
		printf "Ejecucion cancelada. \n"
		echo "2" > inc
		exit
	fi

	# Comprobacion directorio
	if [ -f $DIR/.progreso ] && [ -f temp/pertenencia ] #Comprobacion existencia instalacion incompleta y track de la instalacion en temp
	then
		diranterior=$(cat temp/pertenencia)
		if [ "$diranterior" == "$DIR"  ]; then
			read -p "El directorio especificado ( $DIR ) ya existe y parece que hay una instalacion incompleta. ¿Quiere continuar donde lo dejo (c) o borrarlo y reescribir (b)? (cualquier otro para cancelar): " resp
			case "$resp" in
    				b|B )
        				printf "Se ha borrado $DIR. \n"
					rm -r $DIR
					mkdir $DIR
    				;;
    				c|C )
        				printf "Reanudando ejecucion en $DIR. \n"
    					INCOMPLETA=1
				;;
				*)
					printf "Ejecucion cancelada. \n"
					echo "2" > inc
					exit
				;;
			esac
		else
			read -p  "El directorio $DIR existe y tiene una ejecucion incompleta, pero no es posible reanudarla pues se ha manipulado temp. Para continuar se deben borrar temp y $DIR y empezar de cero, ¿Continuar? (s) (cualquier otro para cancelar) " resp
			case $resp in
				s|S)
					rm -r $DIR
					mkdir $DIR
					rm -r temp
				;;
				*)
                                        printf "Ejecucion cancelada. \n"
                                        echo "2" > inc
                                        exit
				;;
			esac
		fi
	elif [ -f $DIR/.progreso ]; then
			read -p  "El directorio $DIR existe y tiene una ejecucion incompleta, pero no es posible reanudar la ejecucion, pues se ha manipulado temp.  Para continuar se deben borrar temp y $DIR y empezar de cero, ¿Continuar? (s) (cualquier otro para cancelar): "
                        case $resp in
                                s|S)
                                        rm -r $DIR
                                        mkdir $DIR
                                        rm -r temp
                                ;;
                                *)
                                        printf "Ejecucion cancelada. \n"
                                        echo "2" > inc
                                        exit
                                ;;
                        esac
	elif [ -d $DIR ]; then
		if [ -d $DIR/01_Andalucia ]; then # Se comprueba que no se completara ya, puesto que $DIR/.progreso se borra al terminar
			read -p "El directorio especificado ( $DIR ) ya existe y parece que se ejecuto correctamente el programa en el. ¿Desea borrarlo y continuar para recrear los directorios en el? (s) (Cualquier otro para cancelar): " resp
			case $resp in
                                s|S )
                                        printf "Se ha borrado $DIR. \n"
                                        rm -r $DIR
                                        mkdir $DIR
                                ;;
				*)
		                        printf "Ejecucion cancelada. \n"
                                	echo "2" > inc
                                	exit
				;;
			esac
		else
                	read -p "El directorio especificado ( $DIR ) ya existe. Desea continuar en el (c) o borrarlo (b) (Cualquier otro para cancelar): " resp
                	case $resp in
                        	b|B )
                               		printf "Se ha borrado $DIR. \n"
                                	rm -r $DIR
                                	mkdir $DIR
                        	;;
                        	c|C )
                                	printf "Ejecutando en $DIR. \n"
                        	;;
                        	*)
                                	printf "Ejecucion cancelada. \n"
                        		echo "2" > inc # Para cancelar
			        	exit
                        	;;
                	esac
		fi
	else
		mkdir $DIR
	fi

	# Comprobacion directorio temp
	if [ -d temp ] && [ $INCOMPLETA == 0 ]
	then
        	read -p "El directorio temp ya existe, posiblemente de una ejecucion anterior. Si hay una ejecucion incompleta no podra continuarse despues si lo borra. Para poder continuar debe borrarse. ¿Quiere borrarlo? (s) (cualquier otro para cancelar): " resp
        	case $resp in
                	s|S )
                       		printf "Se ha borrado temp. \n"
                        	rm -r temp
                        	mkdir temp
				echo "$DIR" > temp/pertenencia
                	;;
                	*)
                        	printf "Ejecucion cancelada. \n"
		                echo "2" > inc # Para cancelar
				exit
			;;
        	esac
	elif [ $INCOMPLETA == 0 ]; then
		mkdir temp
		echo "$DIR" > temp/pertenencia
	fi

else  # Modo automatico
        if [ -d $DIR ]
        then
		rm -r $DIR
	fi
        if [ -d temp ]
        then
                rm -r temp
        fi
	mkdir $DIR
	mkdir temp
	echo "$DIR" > temp/pertenencia
fi

echo "$INCOMPLETA" > inc
