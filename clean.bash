

dirs=(frame chem share dyn_em dyn_nmm phys main tools wrftladj)

for dir in "${dirs[@]}"; do
    if [ -d $dir ]; then
        ( cd $dir ; echo $dir ; /bin/rm -f core wrf *.f90 *.exe *.kmo *.mod *.o *.obj *.inc *.F90 *.a \
                      db_* Warnings module_state_description.F module_dm.F gmeta \
                      wrfdata whatiread rsl.* show_domain* ) >& /dev/null
    fi   
done

if [ -d var ]; then
    (cd var ; make clean)
fi

( cd tools/CodeBase ; make clean )

( cd inc ; rm -f *.inc namelist.default commit_decl )

find . -name \*.dSYM -exec rm -rf {} \; >& /dev/null

arg="$1"
if [ "$arg" == '-a' -o "$arg" == '-aa' ]; then
    if [ -d var ]; then
        ( cd var ; make superclean )
        ( cd var/obsproc ; make clean )
    fi
    if [ -f Registry/Registry ]; then
        cp Registry/Registry Registry/Registry.backup
        rm -f Registry/Registry
        rm -f Registry/io_boilerplate_temporary.inc
        if [ -f Registry/Registry.rconfig ]; then
            rm -f Registry/Registry.rconfig
        fi
    fi
    rm -fr ./netcdf_links
    rm -fr tools/code_dbase
    ( cd external ; make -i superclean )
    ( cd external/io_grib1/WGRIB ; make clean )
    ( cd external/atm_ocn ; make clean )
    ( cd tools ; rm -f registry gen_comms.c fseeko_test fseeko64_test nc4_test.log ) >& /dev/null
    ( cd inc; rm -f dm_comm_cpp_flags wrf_io_flags.h wrf_status_codes.h ) >& /dev/null
    if [ -f configure.wrf ]; then
        cp configure.wrf configure.wrf.backup
        rm -f configure.wrf >& /dev/null
    fi
    if ( "$arg" != '-aa' ) then
        ( cd run ; rm -f gm* out* fort* ideal* *.exe input_sounding p3_lookupTable_1.dat-3momI_v5.1.6 ; \
	    cp -f namelist.input namelist.input.backup.`date +%Y-%m-%d_%H_%M_%S` ; \
	    rm -f namelist.input ) >& /dev/null
        ( cd test/exp_real ; /bin/rm -f gm* out* fort* real* ) >& /dev/null
        ( cd test ; rm -f */*.exe */ETAMPNEW_DATA* */GENPARM.TBL */LANDUSE.TBL */README.namelist */README.physics_files \
	    */RRTM_DATA */SOILPARM.TBL */VEGPARM.TBL */MPTABLE.TBL */URBPARM.TBL */URBPARM_LCZ.TBL */grib2map.tbl \
	    */CAM_ABS_DATA */CAM_AEROPT_DATA \
	    */CCN_ACTIVATE.BIN \
	    */CAMtr_volume_mixing_ratio.RCP4.5 */CAMtr_volume_mixing_ratio.RCP6 */CAMtr_volume_mixing_ratio.RCP8.5 \
	    */CAMtr_volume_mixing_ratio.A1B */CAMtr_volume_mixing_ratio.A2 */CAMtr_volume_mixing_ratio \
	    */CLM_*DATA */RRTMG_LW_DATA */RRTMG_SW_DATA \
	    */p3_lookup* */BROADBAND_CLOUD_GODDARD.bin \
	    */ozone.formatted */ozone_lat.formatted */ozone_plev.formatted \
	    */aerosol.formatted */aerosol_lat.formatted */aerosol_plev.formatted */aerosol_lon.formatted \
	    */kernels.asc_s_0_03_0_9 */bulkradii.asc_s_0_03_0_9 */bulkdens.asc_s_0_03_0_9 \
	    */constants.asc \
	    */masses.asc */kernels_z.asc */capacity.asc */termvels.asc */coeff_p.asc */coeff_q.asc \
	    */gribmap.txt */tr??t?? */co2_trans */namelist.output */ishmael-gamma-tab.bin \
	    */eclipse_besselian_elements.dat \
	    */HLC.TBL */wind-turbine-1.tbl \
              */ishmael-qi-qc.bin */ishmael-qi-qr.bin ) >& /dev/null
        ( cd test/em_fire; rm -rf two_fires rain )
    elif [ "$arg" == '-aa' ]; then
        rm -f configure.wrf.backup
        rm -f Registry/Registry.backup
        rm -f run/namelist.input.backup.*
    fi
fi

if [ -d chem ]; then
    if [ -d chem/KPP ]; then
        ( cd chem/KPP; ./clean_kpp.bash ; rm -f if_required ) 
    fi
fi
#cms--

#wrf_hydro++
if [ -f hydro/Makefile.comm ]; then
    (cd hydro; make -f Makefile.comm clean)
fi
#wrf_hydro--