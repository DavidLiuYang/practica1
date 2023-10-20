#!/bin/bash
echo Introduce una opción ; read opcion 
codi_pais='xx'
codi_ciudad='xx'
#En esta parte se declara el intérprete y se pide al usuario que introduzca una opcion que se guarda en la variable $opcion. Después se inicializan dos variables globales con valor inicial 'xx'

while [[ $opcion != "q" ]] #este bucle permite la repetición constante de "introduzca una opción" y "la función en sí" hasta que se introduzca la "q", momento en el cual se saldrá del codigo y se imprimirá por pantalla "Saliendo de la aplicación".
do
	case $opcion in	#Comienzo del case y sus diferentes opciones
	"lp") 
		cut -d',' -f7,8 cities.csv | uniq | column -s ','
	;;
	"sc") 
		echo "Nombre del país" ; read pais #Se introduce el nombre del país y se busca su ID para guardarlo en la variable $codi_pais
		if [[ -z "$pais" ]]
		then 
			codi_pais=$codi_pais
		else 
			if  [[ -n "grep $pais cities.csv" ]]
			then 
				codi_pais="$(cut -d',' -f7,8 cities.csv | grep -w $pais | cut -d',' -f1 | uniq)"
			else
				codi_pais='xx'
			fi
		fi
	
	;;
	"se") 
		echo "Nombre de la ciudad" ; read ciudad #Lo mismo que el "sc" pero con la variable $codi_ciudad
		if [[ -z "$ciudad" ]]
		then 
			codi_ciudad=$codi_ciudad
		else 
			if [[ -n "grep $ciudad cities.csv" ]]
			then 
				codi_ciudad="$(cut -d',' -f4,5,7 cities.csv | grep -w $codi_pais | grep -w $ciudad | cut -d',' -f1 | uniq)"
			else 
				codi_ciudad='xx'
			fi
		fi
	;;
	"le") #Las diferentes opciones de listado dependiendo de la $codi_pais
		cut -d ',' -f1,2,7 cities.csv | grep -w $codi_pais | cut -d',' -f1,2 | awk -F',' '{print $1, $2}' 
	;;
	"lcp") 
		cut -d ',' -f2,7,11 cities.csv | grep -w $codi_pais | cut -d',' -f1,3 | awk -F',' '{print $1, $2}'  
	;;	
	"ecp")
		cut -d ',' -f2,7,11 cities.csv | grep -w $codi_pais | cut -d',' -f1,3 |awk -F',' '{print $1, $2}' > "archivosp.csv/$codi_pais.csv"
 	;;	
        "ce") #Las opciones de listado dependientes de la variale $codi_pais y $codi_ciudad
		cut -d',' -f2,4,7,11 cities.csv | grep -w $codi_pais | grep -w $codi_ciudad | cut -d',' -f1,4 | awk -F',' '{print $1, $2}' 
	;;
	"lce")
		cut -d',' -f2,4,7,11 cities.csv | grep -w $codi_pais | grep -w $codi_ciudad | cut -d',' -f1,4 | awk -F',' '{print $1, $2}' > "archivosc.csv/${codi_pais}_${codi_ciudad}.csv"
	;;
	"gwd") #Aquí se busca un pueblo y se obtiene su información de la páginga WikiData.org
		echo Introduce el nombre del pueblo ; read pueblo 
		wdid="$(cut -d ',' -f2,4,7,11 cities.csv | grep -w $codi_pais | grep -w $codi_ciudad | grep -w $pueblo | cut -d ',' -f4)"
	if [[ -z "$wdid" ]]
		then 
			echo El pueblo seleccionado no tiene WikiDataID
		else 
			curl https://www.wikidata.org/wiki/Special:Entity Data//$wdid.json > "archivosj.csv/$wdid.json"
	fi
	;;
        "est") #Se hace un recuento con el comando "awk", se guarda en una variable y se imprime por pantalla
		nord="$(awk -F',' '{ if ($9 > 0) nord +=1 } END { print nord }' cities.csv)" 
		sur="$(awk -F',' '{ if ($9 < 0) sur +=1 } END { print sur} ' cities.csv)"
		est="$(awk -F',' '{ if ($10 > 0) oriental +=1 } END { print oriental }' cities.csv)"
		oest="$(awk -F',' '{ if ($10 < 0) occidental +=1 } END { print occidental }' cities.csv)"
		NoUbic="$(awk -F',' '{ if ($10 == 0 && $9 == 0) NoUbic +=1 } END { print NoUbic }' cities.csv)"
		NoWID="$(awk -F',' '{ if ($11 == "") NoWID +=1 } END { print NoWID }' cities.csv)"
	echo Nord $nord Sur $sur Est $est Oest $oest NoUbic $NoUbic No WDId $NoWID

	;;	
	esac #Se acaba el case y se pide al usuario que introduzca una opción, repitiendose el bucle.
        echo Introduce una opción ; read opcion       
done #Al acabar el bucle, cuando el usuario introduce una "q", se imprime "saliendo de la aplicación.
echo Saliendo de la aplicación








