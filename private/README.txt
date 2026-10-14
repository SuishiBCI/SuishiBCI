private/ — BDF reader MEX (not for sample data)
================================================

Bundled binaries
----------------
  suieeg_load_bdf.mexw64   Windows 64-bit MEX
  suieeg_load_bdf.mexa64   Linux 64-bit MEX (glnxa64)

Usage
-----
  pop_SuiEEG_load.m calls suieeg_load_bdf via MATLAB private-folder rules.
  Users do not need to add this folder to the path.

Rebuild (developers)
--------------------
  Source: mex/MEX_BDF_RW/ in the MEX source repo (pop_loadTUNEXONDT.cpp + edflib/)

  Windows — Visual Studio project or:

    mex -output suieeg_load_bdf pop_loadTUNEXONDT.cpp

  Linux — from MEX_BDF_RW/ (requires g++-11 on Ubuntu with new default g++):

    sudo apt install gcc-11 g++-11
    matlab -nodesktop -nosplash -batch build_mex_linux
    cp suieeg_load_bdf.mexa64 <plugin>/private/

  Copy output here as suieeg_load_bdf.mexw64 or .mexa64.

Other folders
-------------
  Sample BDF for testing:  ../sample_data/
  Demo script:             ../demo/demo_SuiEEG_load.m

See ../README.md for installation and usage.
