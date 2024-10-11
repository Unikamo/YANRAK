inputfile="$1"

nasm -f bin -o "${inputfile}.bin" "${inputfile}.s"
#ld -o "${inputfile}" "${inputfile}.o"
