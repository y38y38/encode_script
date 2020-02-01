echo $1 
echo $2
echo $3 
echo $4

python rd.py ${1}/akiyo_result.txt ${2}      ${3}/result_akiyo.txt ${4}
mv frame_size.png akiyo.png
python rd.py ${1}/coastguard_result.txt ${2} ${3}/result_coastguard.txt ${4}
mv frame_size.png coastguard.png
python rd.py ${1}/flower_result.txt ${2}     ${3}/result_flower.txt ${4}
mv frame_size.png flower.png
python rd.py ${1}/soccer_result.txt ${2}     ${3}/result_soccer.txt ${4} 
mv frame_size.png soccer.png
python rd.py ${1}/washdc_result.txt ${2}     ${3}/result_washdc.txt ${4} 
mv frame_size.png washdc.png

#python rd.py ${1}/result_akiyo.txt ${2}      ${3}/result_akiyo.txt ${4}
#mv frame_size.png akiyo.png
#python rd.py ${1}/result_coastguard.txt ${2} ${3}/result_coastguard.txt ${4}
#python rd.py ${1}/result_flower.txt ${2}     ${3}/result_flower.txt ${4}
#python rd.py ${1}/result_soccer.txt ${2}     ${3}/result_soccer.txt ${4} 
#python rd.py ${1}/result_washdc.txt ${2}     ${3}/result_washdc.txt ${4} 
