OUTPUT_DIR=./output/
INPUT_DIR=$HOME/yuv_file/
AVC_DIR=$HOME/jm/JM/
FRAME_NUM=300
QP=35
mkdir -p ${OUTPUT_DIR}
cat /dev/null > ./${OUTPUT_DIR}/result.txt
for file in $INPUT_DIR/*.yuv
do

    OUTPUT_FILE=`basename ${file%.*}`
    echo $OUTPUT_FILE
    $AVC_DIR/bin/lencod.exe -p InputFile=${file} -p OutputFile=./${OUTPUT_DIR}/${OUTPUT_FILE}.bin -p QPISlice=${QP} QPPSlice=${QP} QPBSlice=${QP} > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt
    tail -n 15  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_result.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_time_tmp.txt
    head -n 1   ./${OUTPUT_DIR}/${OUTPUT_FILE}_time_tmp.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt
    cat ./${OUTPUT_DIR}/${OUTPUT_FILE}_time.txt| sed 's/[\t ]\+/\t/g'|cut -f9 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt
    wc -c < ./${OUTPUT_DIR}/${OUTPUT_FILE}.bin > ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt
    $AVC_DIR/bin/ldecod.exe -p InputFile=./${OUTPUT_DIR}/${OUTPUT_FILE}.bin -p OutputFile=./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv
    $AVC_DIR/bin/ffmpeg -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i ${file} -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i  ./${OUTPUT_DIR}/${OUTPUT_FILE}_decode.yuv -vframes $FRAME_NUM -filter_complex psnr -an -f null -  2>  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt
    tail -n 1  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr.txt >  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt
    cut -d ' ' -f5 ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr2.txt | cut -d ':' -f2 > ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt
    echo -n ${OUTPUT_FILE} ',' ${QP} ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_psnr3.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_size.txt | tr -d '\n' >> ./${OUTPUT_DIR}/result.txt
    echo -n ',' >> ./${OUTPUT_DIR}/result.txt
    cat  ./${OUTPUT_DIR}/${OUTPUT_FILE}_encode_time.txt  >> ./${OUTPUT_DIR}/result.txt

done
