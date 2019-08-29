#!/bin/bash

AVC_DIR=$HOME/jm/JM/
FRAME_NUM=300
cat /dev/null > ./${OUTPUT_DIR}/result.txt

if [ $# != 1 ]; then
    echo "no input file"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "input file not found"
    exit 1
fi 

BASE_NAME=`basename ${1%.*}`
OUTPUT_DIR=./output_$BASE_NAME
mkdir -p $OUTPUT_DIR

INPUT_FILE=$1

for QP in 29 31 33 35 37 39 41 
do

    OUTPUT_FILE=`basename ${INPUT_FILE%.*}`
    echo $OUTPUT_FILE
    $AVC_DIR/bin/lencod.exe -p InputFile=${INPUT_FILE} -p OutputFile=./${OUTPUT_DIR}/${OUTPUT_FILE}.bin -p QPISlice=${QP} QPPSlice=${QP} QPBSlice=${QP} > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt
    tail -n 15  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_time_tmp.txt
    head -n 1   ./${OUTPUT_DIR}/${OUTPUT_FILE}_time_tmp.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt
    cat ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt| sed 's/[\t ]\+/\t/g'|cut -f9 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt
    wc -c < ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin > ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt
    $AVC_DIR/bin/ldecod.exe -p InputFile=./${OUTPUT_DIR}/${OUTPUT_FILE}.bin -p OutputFile=./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv
    $AVC_DIR/bin/ffmpeg -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i ${INPUT_FILE} -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i  ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv -vframes $FRAME_NUM -filter_complex psnr -an -f null -  2>  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt
    cut -d ' ' -f5 ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt | cut -d ':' -f2 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt
    echo -n ${QP} ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt  >> ./${OUTPUT_DIR}/result.txt

done
