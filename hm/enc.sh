OUTPUT_DIR=./output/
INPUT_DIR=$HOME/yuv_file/
HEVC_DIR=$HOME/hm/HM-16.9/
FRAME_NUM=3
QP=35
cat /dev/null > ./${OUTPUT_DIR}/result.txt
for file in $INPUT_DIR/*.yuv
do

    OUTPUT_FILE=`basename ${file%.*}`
    echo $OUTPUT_FILE

    $HEVC_DIR/bin/TAppEncoderStatic -i ${file} -c $HEVC_DIR/cfg/encoder_randomaccess_main.cfg -fr 29.97 -f $FRAME_NUM -wdt 352 -hgt 288 --InputBitDepth=8 --OutputBitDepth=8  -q ${QP} -b ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt
    cat ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt| sed 's/[\t ]\+/\t/g'|cut -f4 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt
    wc -c < ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin > ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt
    $HEVC_DIR/bin/TAppDecoderStatic -b ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin  -o ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv 
    $HEVC_DIR/bin/ffmpeg -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i ${file} -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i  ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv -vframes $FRAME_NUM -filter_complex psnr -an -f null -  2>  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt
    cut -d ' ' -f5 ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt | cut -d ':' -f2 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt
    echo -n ${OUTPUT_FILE} ',' ${QP} ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt  >> ./${OUTPUT_DIR}/result.txt

done
