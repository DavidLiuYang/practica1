#!/bin/bash
echo Introduce una opción ; read opcion 
codi_pais='aws'
codi_ciudad='xx'


while [[ $opcion != "q" ]]
do
	case $opcion in
	"q") 
		echo Saliendo de la aplicación
	;;	
	"lp") 
		cut -d',' -f7,8 cities.csv | uniq | column -s ','
	;;
	"sc") 
		echo "Nombre del país" ; read pais
		if [[ -z "$pais" ]]
		then 
			codi_pais=$codi_pais
		else 
			if  [[ -n "grep $pais cities.csv" ]]
			then 
				codi_pais="$(cut -d',' -f7,8 cities.csv | grep -w $pais | cut -d',' -f1 | uniq)"
			else
				codi_pais='aws'
			fi
		fi
	
	;;
	"se") 
		echo "Nombre de la ciudad" ; read ciudad	
		if [[ -z "$ciudad" ]]
		then 
			codi_ciudad=$codi_ciudad
		else 
			if [[ -n "grep $ciudad cities.csv" ]]
			then 
				codi_ciudad="$(cut -d',' -f4,5 cities.csv | grep -w $ciudad | cut -d',' -f1 | uniq)"
			else 
				codi_ciudad='xx'
			fi
		fi
	;;
	"le")
		cut -d ',' -f1,2,7 cities.csv | grep -w $codi_pais | cut -d',' -f1,2 | column -s ', ' 
		
	esac
	echo $codi_pais
	echo $codi_ciudad

        echo Introduce una opción ; read opcion       
done
