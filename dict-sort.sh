#!/bin/bash
echo "sortowanie plików słownikowych..."


files="*dict" # input files
#files="super.dict"
outputfile="wynik.dict"
inputfile="temp.temp"
count=3    #number of CPU threads

for i in $files
do
echo "Sorting file $i cutting wrong characters, deleteing spaces"
ls $files
pv $i | awk ' length($0) > 8 && length($0) < 15 ' | tr -cd '\11\12\15\40-\176' | sed '/^[[:space:]]*$/d' > ${i}_out &
done
wait

pv ${i}*_out > $inputfile
rm ${files}_out

#split -n l/$count $inputfile _pawk$$  
#rm $inputfile
#for file in _pawk$$*; do
echo "removeing duplicates from file $i"
#    awk '!seen[$0]++' $file  > ${file}.out &
#done
pv $inputfile | sort -u --parallel=$count  > $outputfile
wait
#cat _pawk$$*.out > $outputfile
#rm _pawk$$*
rm $inputfile
echo "sorting by length"
pv $outputfile | awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2- > ${outputfile}_2 
echo "Output file: ${outputfile}_2"


