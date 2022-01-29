
listdir () {
    i=0
    while read line
    do
        array[ $i ]="$line"        
        (( i++ ))
    done < <(ls $1)
}
 

if [ -e configure.kpp ]; then
rm -f configure.kpp
fi
echo "# DO NOT EDIT! Placeholder for automatically generated file"  >&   configure.kpp

# remove the traces of KPP
if [ -e ../Makefile_org ]; then
cp  -f ../Makefile_org  ../Makefile
rm -f ../Makefile_org
fi


if [ -e if_required ]; then
rm if_required 
fi
touch if_required

# remove automatically genereated files in chem directory
rm -f ../*kpp* >> if_required

#kpp 
listdir ./kpp
for kdir in "${array[@]}"; do
kdir=./kpp/$kdir
echo $kdir >> if_required
( cd $kdir; touch Makefile.defs; make clean ) >> if_required
( cd $kdir; touch Makefile.defs; rm -f  Makefile.defs ) >> if_required
done
unset array

# remove links in util/wkc
( cd util/wkc; ./linker.bash unlink ) >> if_required

#coupler
( cd util/wkc; make clean; make -f Makefile.tuv clean ) >> if_required



# mechanisms
listdir ./mechanisms
for mdir in "${array[@]}"; do
mdir=./mechanisms/$mdir
echo $mdir >> if_required
( cd $mdir; rm -f *.f90 *.map Makefil* *~ core.* ) >> if_required

done

rm -f ../../Registry_tmp.*_wk* >> if_required

#./documentation/latex/clean


# configure file
rm -f configure.kpp

if [ -e  util/mod_registry.temp ]; then
rm -f util/mod_registry.temp
fi

exit 0
