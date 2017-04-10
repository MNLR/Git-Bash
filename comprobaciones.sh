
DIR=$1
AUT=$2

if [ $AUT != 1 ]
then

	read -p "Se escribiran las series temporales en $DIR. Introduzca s para continuar: " resp
	if [ "$resp" != "s" ]
	then
		printf "Ejecucion cancelada. \n"
		exit
	fi

	# Comprobacion directorio
	if [ -d $DIR ]
	then
		read -p "El directorio especificado ( $DIR ) ya existe. Espere errores si no lo borra: Si alguna serie se comenzo a escribir se seguira escribiendo en ella. ¿Quiere borrarlo? (s/n) (cualquier otro para cancelar): " resp
		case $resp in
    			s|S )
        			printf "Se ha borrado $DIR. \n"
				rm -r $DIR
				mkdir $DIR
    			;;
    			n|N )
        			printf "Se sobreescribira en $DIR. \n"
    			;;
			*)
				printf "Ejecucion cancelada. \n"
				exit
			;;
		esac
	else
		mkdir $DIR
	fi

	# Comprobacion directorio temp
	if [ -d temp ]
	then
        	read -p "El directorio temp ya existe, posiblemente de una ejecucion anterior. Espere errores si no lo borra.  ¿Quiere borrarlo? (s/n) (cualquier otro para cancelar): " resp
        	case $resp in
                	s|S )
                       		printf "Se ha borrado temp. \n"
                        	rm -r temp
                        	mkdir temp
                	;;
                	n|N )
                        	printf "Se sobreescribira en temp. \n"
                	;;
                	*)
                        	printf "Ejecucion cancelada. \n"
				exit
			;;
        	esac
	else
       		mkdir temp
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
fi
