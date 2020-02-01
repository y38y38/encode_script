./ffmpeg -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i $1 -f rawvideo -vcodec rawvideo -s 352x288 -pix_fmt yuv420p -i $2 -filter_complex psnr=${1%.yuv}_psnr.txt -an -f null -
