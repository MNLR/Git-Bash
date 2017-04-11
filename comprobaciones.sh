
DIR=$1
AUT=$2
INCOMPLETA=0

if [ $AUT != 1 ]
then
	read -p "Se escribiran las series temporales en $DIR. Introduzca s para continuar: " resp
	if [ "$resp" != "s" ]
	then
		printf "Ejecucion cancelada. \n"
		exit
	fi

	# Comprobacion directorio
	if [ -d $DIR ] && [ -f $DIR/.progreso ]
	then
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
				exit
			;;
		esac
	elif [ -d $DIR ]; then
                read -p "El directorio especificado ( $DIR ) ya existe. Desea continuar en el (c) o borrarlo (b) (Cualquier otro para cancelar) " resp
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
                                exit
                        ;;
                esac
	else
		mkdir $DIR
	fi

	# Comprobacion directorio temp
	if [ -d temp ] && [ $INCOMPLETA == 0 ]
	then
        	read -p "El directorio temp ya existe, posiblemente de una ejecucion anterior. Para poder continuar debe borrarse.  ¿Quiere borrarlo? (s) (cualquier otro para cancelar): " resp
        	case $resp in
                	s|S )
                       		printf "Se ha borrado temp. \n"
                        	rm -r temp
                        	mkdir temp
                	;;
                	*)
                        	printf "Ejecucion cancelada. \n"
				exit
			;;
        	esac
	elif [ $INCOMPLETA == 0 ]; then
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

echo "$INCOMPLETA" > temp/inc
