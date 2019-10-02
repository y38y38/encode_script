#!/bin/bash

CODEC_DIR=$HOME/vtm/VVCSoftware_VTM-VTM-6.1/
FRAME_NUM=1


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
cat /dev/null > ./result_${BASE_NAME}.txt

INPUT_FILE=$1


for QP in 25 27 29 31 33 35 37 39  
do
    OUTPUT_FILE=`basename ${INPUT_FILE%.*}`_${QP}
    echo $OUTPUT_FILE


    $CODEC_DIR/bin/EncoderAppStatic  -i ${INPUT_FILE} -c $CODEC_DIR/cfg/encoder_intra_vtm.cfg  -fr 29.97 -f $FRAME_NUM -wdt 352 -hgt 288 --InputBitDepth=8 --OutputBitDepth=8 --InternalBitDepth=8 -q ${QP} -b ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt
    cat ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt| sed 's/[\t ]\+/\t/g'|cut -f4 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt
    wc -c < ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin > ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt
    $CODEC_DIR/bin/DecoderAppStatic -b ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin  -o ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv 

    $CODEC_DIR/bin/ffmpeg -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i ${INPUT_FILE} -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i  ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv -vframes $FRAME_NUM -filter_complex psnr -an -f null -  2>  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt
    cut -d ' ' -f5 ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt | cut -d ':' -f2 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt
    echo -n ${QP} ',' >> ./result_${BASE_NAME}.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt | tr -d '\n' >> ./result_${BASE_NAME}.txt
    echo -n ',' >> ./result_${BASE_NAME}.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt | tr -d '\n' >> ./result_${BASE_NAME}.txt
    echo -n ',' >> ./result_${BASE_NAME}.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt  >> ./result_${BASE_NAME}.txt

done
#rm ./${OUTPUT_DIR}/*.yuv


