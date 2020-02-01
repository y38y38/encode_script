echo $1 
echo $2
echo $3 
echo $4

python rd.py ${1}/result_akiyo.txt ${2}      ${3}/result_akiyo.txt ${4} ${5}/result_akiyo.txt ${6}
mv frame_size.png akiyo.png
python rd.py ${1}/result_coastguard.txt ${2} ${3}/result_coastguard.txt ${4} ${5}/result_coastguard.txt ${6}
mv frame_size.png coastguard.png
python rd.py ${1}/result_flower.txt ${2}     ${3}/result_flower.txt ${4}   ${5}/result_flower.txt ${6}
mv frame_size.png flower.png
python rd.py ${1}/result_soccer.txt ${2}     ${3}/result_soccer.txt ${4}     ${5}/result_soccer.txt ${6} 
mv frame_size.png soccer.png
python rd.py ${1}/result_washdc.txt ${2}     ${3}/result_washdc.txt ${4}   ${5}/result_washdc.txt ${6} 
mv frame_size.png washdc.png

#python rd.py ${1}/result_akiyo.txt ${2}      ${3}/result_akiyo.txt ${4}
#mv frame_size.png akiyo.png
#python rd.py ${1}/result_coastguard.txt ${2} ${3}/result_coastguard.txt ${4}
#python rd.py ${1}/result_flower.txt ${2}     ${3}/result_flower.txt ${4}
#python rd.py ${1}/result_soccer.txt ${2}     ${3}/result_soccer.txt ${4} 
#python rd.py ${1}/result_washdc.txt ${2}     ${3}/result_washdc.txt ${4} 
