$1 -f rawvideo -pix_fmt yuv420p -s 1920x1080 -i $2 -r 29.97 -profile high -crf 20 ${2##.yuv}.mp4
