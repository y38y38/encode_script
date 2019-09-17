#!/bin/bash

CODEC_DIR=$HOME/aom_build/
FRAME_NUM=300


if [ $# != 1 ]; then
    echo "no input file"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "input file not found"
    exit 1
fi 

BASE_NAME=`basename ${1%.*}`
cat /dev/null > ./${OUTPUT_DIR}/result_${BASE_NAME}.txt
OUTPUT_DIR=./output_$BASE_NAME
mkdir -p $OUTPUT_DIR

INPUT_FILE=$1


for QP in 35 37 39 41 43   
do
    OUTPUT_FILE=`basename ${INPUT_FILE%.*}`_${QP}
    echo $OUTPUT_FILE


    (\time -f %s $CODEC_DIR/aomenc  --width=352 --height=288 --fps=30000/1001 --bit-depth=8 --max-q=${QP} -o ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin ${INPUT_FILE} )> ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt
    #cat ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt| sed 's/[\t ]\+/\t/g'|cut -f4 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt
    wc -c < ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin > ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt
    $CODEC_DIR/aomdec -o ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin
    $CODEC_DIR/ffmpeg -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i ${INPUT_FILE} -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i  ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv -vframes $FRAME_NUM -filter_complex psnr -an -f null -  2>  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt
    cut -d ' ' -f5 ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt | cut -d ':' -f2 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt
    echo -n ${QP} ',' >> ./${OUTPUT_DIR}/result_${BASE_NAME}.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result_${BASE_NAME}.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result_${BASE_NAME}.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result_${BASE_NAME}.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt  >> ./${OUTPUT_DIR}/result_${BASE_NAME}.txt

done
rm ./${OUTPUT_DIR}/*.yuv
