


if [ $#argv != 1 ]; then
echo Error: Usage: linker.csh option 
exit
fi 

files=( data.c data.h misc.c my_strtok.c  protos.h reg_parse.c registry.h  type.c sym.c sym.h symtab_gen.c )


for file in "${files[@]}"; do
if  [ $argv[1] == 'link' ]; then
    ln -s ../../../../tools/$file
fi
if  [ $argv[1] == 'unlink' ]; then
    rm -f $file
fi
done


exit
 
