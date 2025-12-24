#
#  <<  run SRAC  >>
#
#===============================================================================
#  Test.ps1 : Test problem to check SRAC installation
#            UO2 pin cell calculation in LWR next generation
#            fuel benchmark (No burn-up)
#  Options : Pij(Geometry type IGT=4), PEACO
#===============================================================================
#    
# Fortran logical unit usage (allocate if you need)
#
#       The meaning of each file depends on sub-programs used in SRAC.
#       [ ]:important files for users. 
# 
#   1   binary (ANISN,TWOTRAN,CIATION)
#   2   binary (ANISN,CITATION), scratch
#   3   binary (SRAC,ANISN,TWOTRAN,CITATION), scratch
#   4   binary (PIJ,ANISN,TWOTRAN), scratch
# [ 5]  text:80 standard input
# [ 6]  text:137 standard output, monitoring message
#   8   binary (ANISN,TWOTRAN), angular flux in TWOTRAN
#   9   binary (TWOTRAN,CITATION)
#               flux map in CITATION, angular flux in TWOTRAN
#  10   binary (ANISN,TWOTRAN,CITATION), scratch
#  11   binary (TWOTRAN,CITATION), Sn constants in TWOTRAN
#  12   binary (TWOTRAN), restart file for TWOTRAN
#  13   binary (TWOTRAN,CITATION), restart file for TWOTRAN & CITATION
#  14   binary (TWOTRAN,CITATION), scratch
#  15   binary (CITATION), scratch (fast I/O device may be effective)
#  16   binary (CITATION), scratch
#  17   binary (CITATION), fixed source in CITATION
#  18   binary (CITATION), scratch
#  19   binary (CITATION), scratch 
#  20   binary (CITATION), scratch
#  21   binary (PIJ), scratch
#  22   binary (PIJ,CITATION), scratch
#  26   binary (CITATION), scratch
#  28   binary (CITATION), scratch
#  31   text:80 (SRAC-CVMACT,CITATION), macro-XS interface for CITATION
#  32   binary (PIJ,ANISN,TWOTRAN,TUD,CITATION)
#               fixed source for TWOTRAN, power density map in CITATION 
#  33   binary (PIJ,TWOTRAN,TUD), total flux in TWOTRAN & TUD
#  49   device internally used to access PDS file
# [50]  text:80 burnup chain library (SRAC-BURNUP) 
#  52   binary (SRAC-BURNUP), scratch
#  81   binary (PIJ), scratch
#  82   binary (PIJ), scratch
#  83   binary (PIJ), scratch
#  84   binary (PIJ), scratch
#  85   binary data table (PIJ), always required in PIJ
# [89]  plot file : PostScript (SRAC-PEACO,PIJ)
#  91   text:80 (CITATION), scratch
#  92   binary (CITATION), scratch
#  93   text:80 (SRAC-BURNUP), scratch
#  95   text:80 (SRAC-DTLIST), scratch
#  96   binary (SRAC-PEACO), scratch
#  97   binary (SRAC-BURNUP), scratch
# [98]  text:137 (SRAC-BURNUP) summary of burnup results
# [99]  text:137 calculated results
#
#===============================================================================
#

#
#============= Set by user =====================================================
#
#  LMN    : executable command of SRAC (SRAC/bin/*)
#  BRN    : burnup chain data          (SRAC/lib/burnlibT/*)
#  ODR    : directory in which output data will be stored
#  CASE   : case name which is refered as name of output files and PDS directory
#  WKDR   : working directory in which scratch files will be made and deleted
#  PDSD   : top directory name of PDS file
#

$SRAC_DIR = "C:\SRACW\SRAC"
$LMN = "SRAC.exe"
$BRN = "u4cm6fp50bp16T"
$ODR = "$SRAC_DIR\smpl\outp"
$Case = "fa_standard"
$PDSD = "$SRAC_DIR\tmp"

#
#=============  mkdir for PDS  =================================================
#
#  PDS_DIR : directory name of PDS files
#  PDS file names must be identical with those in input data
#
$PDS_DIR = "$PDSD\$Case"
mkdir "$PDS_DIR"
mkdir "$PDS_DIR\UFAST"
mkdir "$PDS_DIR\UTHERMAL"
mkdir "$PDS_DIR\UMCROSS"
mkdir "$PDS_DIR\MACROWRK"
mkdir "$PDS_DIR\MACRO"
mkdir "$PDS_DIR\FLUX"
mkdir "$PDS_DIR\MICREF"

#  
#=============  Change if you like =============================================
#

$LM = "$SRAC_DIR/bin/$LMN"
$DATE = Get-Date -uformat "%Y.%m.%d.%H.%M.%S" 
$WKDR = "$SRAC_DIR/SRACtmp.$Case.date $Date"
mkdir $WKDR
#
#-- File allocation
#  fu89 is used in any plot options, fu98 is used in the burnup option
#  Add other units if you would like to keep necessary files.
   $env:fu50 =  "$SRAC_DIR/lib/burnlibT/$BRN"
   $env:fu85 =  "$SRAC_DIR/lib/kintab.dat"
  $env:fu89 =  "$ODR/$CASE.SFT89.$DATE.SAMPLE.ps"
  $env:fu98 =  "$ODR/$CASE.SFT98.$DATE.SAMPLE"
   $env:fu99 =  "$ODR/$CASE.SFT99.$DATE.SAMPLE"
   $OUTLST   =  "$ODR/$CASE.SFT06.$DATE.SAMPLE"
#   $env:fu99 =  "$ODR/$CASE.SFT99.SAMPLE"
#   $OUTLST   =  "$ODR/$CASE.SFT06.SAMPLE"
   
#
#=============  Exec SRAC code with the following input data ===================
#

cd $WKDR
$Input = @"
FP01 : UO2 1.6% enrichment (A4)
UO2 pin cell problem in LWR next generation fuel benchmark (No burn-up)
************************************************************************
*  Benchmark Reference :
*  A.Yamamoto, T.Ikehara, T.Ito, and E.Saji : "Benchmark Problem for
*  Reactor Physics Study of LWR Next Generation Fuels",
*  J. Nucl. Sci. Technol., Vol.39, No.8, pp.900-912, (2002).
************************************************************************
1 1 1 1 2   1 4 3 -2 1   0 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
*- PDS files ------2---------3---------4---------5---------6---------7--
* Note : All input line must be written in 72 columns except comments
*        even when environmental variables are expanded.
C:/SRACW/SRACLIB-EDF70/pds/pfast   Old  File
C:/SRACW/SRACLIB-EDF70/pds/pthml   O    F
C:/SRACW/SRACLIB-EDF70/pds/pmcrs   O    F
$PDS_DIR/UFAST      Scratch  Core
$PDS_DIR/UTHERMAL   S        C
$PDS_DIR/UMCROSS    S        C
$PDS_DIR/MACROWRK   S        C
$PDS_DIR/MACRO      S        C
$PDS_DIR/FLUX       S        C
$PDS_DIR/MICREF     S        C
************************************************************************
62 45  3 3 /  107 group => 6 (=3+3) group
62(1)      /  Energy group structure suggested for LWR analyses
45(1)      /
20 21 21  / Fast 6 group
15 15 15  / Thermal 6 group
***** Enter one blank line after input for energy group structure

***** Input for PIJ (Collision Probability Method)
4 8 8 4 1   1 8 0 0 0   5 0 10 15 0   0 45 0         / Pij Control
0 50 50 5 5 5 -1  0.0001 0.00001 0.001 1.0 10. 0.5  / PIJ Block-2
1 1 1 2 3 4 4 4  /  R-S
4(1)             /  X-R
1 2 3 4          /  M-R
0.0  0.226  0.320  0.392  0.400  0.457  0.544  0.619  0.686    / RX (menggunakan P/D 1.5)
****** Input for material specification*****************************
4 / NMAT
FU01X01X  0 5  1073.15  0.784    0.0  / 1 : UO2 Fuel
XU040000  2 0  3.0131E-06    /1 U-234
XU050000  2 0  3.7503E-04    /2 U-235
XU080000  2 0  2.2625E-02    /3 U-238
XO060000  0 0  4.5897E-02    /4 O-16
XO070000  0 0  1.7436E-05    /5 O-17
*XO080000  0 0  9.2032E-05    /6 O-18
HE01X02X  0 2  773.15  0.016     0.0  / 2 : Gap Helium
XHE30000  0 0  2.5108E-10       /1 Helium-3
XHE40000  0 0  1.8737E-04       /2 Helium-4
CL01X03X  0 25  598.15  0.114     0.0  / 3 : Cladding Zirconium-Alloy
XCR00000  0 0  3.2962E-06       /1 Cr-50
XCR20000  0 0  6.3564E-05       /2 Cr-52
XCR30000  0 0  7.2076E-06       /3 Cr-53
XCR40000  0 0  1.7941E-06       /4 Cr-54
XFE40000  0 0  8.6698E-06       /5 Fe-54
XFE60000  0 0  1.3610E-04       /6 Fe-56
XFE70000  0 0  3.1431E-06       /7 Fe-57
XFE80000  0 0  4.1829E-07       /8 Fe-58
XO060000  0 0  3.0744E-04    /9 O-16
XO070000  0 0  1.1680E-07    /10 O-17
*XO080000  0 0  6.1648E-07    /11 O-18
XSN20000  0 0  4.6735E-06       /12 Sn-112
XSN40000  0 0  3.1799E-06       /13 Sn-114
XSN50000  0 0  1.6381E-06       /14 Sn-115
XSN60000  0 0  7.0055E-05       /15 Sn-116
XSN70000  0 0  3.7003E-05       /16 Sn-117
XSN80000  0 0  1.1669E-04       /17 Sn-118
XSN90000  0 0  4.1387E-05       /18 Sn-119
XSNC0000  0 0  1.5697E-04       /19 Sn-120
XSNE0000  0 0  2.2308E-05       /20 Sn-122
XSNG0000  0 0  2.7897E-05       /21 Sn-124
XZR00000  0 0  2.1828E-02       /22 Zr-90
XZR10000  0 0  4.7601E-03       /23 Zr-91
XZR20000  0 0  7.2759E-03       /24 Zr-92
XZR40000  0 0  7.3734E-03       /25 Zr-94
XZR60000  0 0  1.1879E-03       /26 Zr-96
MO01X04X  0 2  573.15  0.457      0.0  / 4 : Moderator Water
XH01H000  0 0  4.8507E-02    /1 H-1
XO060000  0 0  2.4254E-02    /2 O-16
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  12(1.790E-04) 6(0) 6(1.790E-04)  / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*        -10       -10      -10        -10      -10       -10
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
****** Input for PEACO option
0    / no plot
****** Enter one blank line to terminate repeatation on calculation cases
*------------------------------------------------------------------------------------------ 01 ----------------------------
FP02 : UO2 2.4% enrichment (A4)
UO2 pin cell problem in LWR next generation fuel benchmark (No burn-up)
1 1 1 1 2   1 4 3 -2 1   1 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
****** Input for material specification*****************************
4 / NMAT
FU02X01X  0 5  1073.15  0.784    0.0  / 1 : UO2 Fuel
XU040000  2 0  4.4842E-06    /1 U-234
XU050000  2 0  5.5814E-04    /2 U-235
XU080000  2 0  2.2407E-02    /3 U-238
XO060000  0 0  4.5830E-02    /4 O-16
XO070000  0 0  1.7411E-05    /5 O-17
*XO080000  0 0  9.1898E-05    /6 O-18
HE02X02X  0 2  773.15  0.016     0.0  / 2 : Gap Helium
XHE30000  0 0  2.5108E-10       /1 Helium-3
XHE40000  0 0  1.8737E-04       /2 Helium-4
CL02X03X  0 25  598.15  0.114     0.0  / 3 : Cladding Zirconium-Alloy
XCR00000  0 0  3.2962E-06       /1 Cr-50
XCR20000  0 0  6.3564E-05       /2 Cr-52
XCR30000  0 0  7.2076E-06       /3 Cr-53
XCR40000  0 0  1.7941E-06       /4 Cr-54
XFE40000  0 0  8.6698E-06       /5 Fe-54
XFE60000  0 0  1.3610E-04       /6 Fe-56
XFE70000  0 0  3.1431E-06       /7 Fe-57
XFE80000  0 0  4.1829E-07       /8 Fe-58
XO060000  0 0  3.0744E-04    /9 O-16
XO070000  0 0  1.1680E-07    /10 O-17
*XO080000  0 0  6.1648E-07    /11 O-18
XSN20000  0 0  4.6735E-06       /12 Sn-112
XSN40000  0 0  3.1799E-06       /13 Sn-114
XSN50000  0 0  1.6381E-06       /14 Sn-115
XSN60000  0 0  7.0055E-05       /15 Sn-116
XSN70000  0 0  3.7003E-05       /16 Sn-117
XSN80000  0 0  1.1669E-04       /17 Sn-118
XSN90000  0 0  4.1387E-05       /18 Sn-119
XSNC0000  0 0  1.5697E-04       /19 Sn-120
XSNE0000  0 0  2.2308E-05       /20 Sn-122
XSNG0000  0 0  2.7897E-05       /21 Sn-124
XZR00000  0 0  2.1828E-02       /22 Zr-90
XZR10000  0 0  4.7601E-03       /23 Zr-91
XZR20000  0 0  7.2759E-03       /24 Zr-92
XZR40000  0 0  7.3734E-03       /25 Zr-94
XZR60000  0 0  1.1879E-03       /26 Zr-96
MO02X04X  0 2  573.15  0.457      0.0  / 4 : Moderator Water
XH01H000  0 0  4.8507E-02    /1 H-1
XO060000  0 0  2.4254E-02    /2 O-16
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  12(1.790E-04) 6(0) 6(1.790E-04)  / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*        -10       -10      -10        -10      -10       -10
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
****** Input for PEACO option
0    / no plot
****** Enter one blank line to terminate repeatation on calculation cases
*------------------------------------------------------------------------------------------ 02 ----------------------------
FP03 : UO2 3.1% enrichment (A4)
UO2 pin cell problem in LWR next generation fuel benchmark (No burn-up)
1 1 1 1 2   1 4 3 -2 1   1 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
****** Input for material specification
4 / NMAT
FU03X01X  0 5  1073.15  0.784    0.0  / 1 : UO2 Fuel
XU040000  2 0  5.7987E-06    /1 U-234
XU050000  2 0  7.2175E-04    /2 U-235
XU080000  2 0  2.2253E-02    /3 U-238
XO060000  0 0  4.5853E-02    /4 O-16
XO070000  0 0  1.7420E-05    /5 O-17
*XO080000  0 0  9.1942E-05    /6 O-18
HE03X02X  0 2  773.15  0.016     0.0  / 2 : Gap Helium
XHE30000  0 0  2.5108E-10       /1 Helium-3
XHE40000  0 0  1.8737E-04       /2 Helium-4
CL03X03X  0 25  598.15  0.114     0.0  / 3 : Cladding Zirconium-Alloy
XCR00000  0 0  3.2962E-06       /1 Cr-50
XCR20000  0 0  6.3564E-05       /2 Cr-52
XCR30000  0 0  7.2076E-06       /3 Cr-53
XCR40000  0 0  1.7941E-06       /4 Cr-54
XFE40000  0 0  8.6698E-06       /5 Fe-54
XFE60000  0 0  1.3610E-04       /6 Fe-56
XFE70000  0 0  3.1431E-06       /7 Fe-57
XFE80000  0 0  4.1829E-07       /8 Fe-58
XO060000  0 0  3.0744E-04    /9 O-16
XO070000  0 0  1.1680E-07    /10 O-17
*XO080000  0 0  6.1648E-07    /11 O-18
XSN20000  0 0  4.6735E-06       /12 Sn-112
XSN40000  0 0  3.1799E-06       /13 Sn-114
XSN50000  0 0  1.6381E-06       /14 Sn-115
XSN60000  0 0  7.0055E-05       /15 Sn-116
XSN70000  0 0  3.7003E-05       /16 Sn-117
XSN80000  0 0  1.1669E-04       /17 Sn-118
XSN90000  0 0  4.1387E-05       /18 Sn-119
XSNC0000  0 0  1.5697E-04       /19 Sn-120
XSNE0000  0 0  2.2308E-05       /20 Sn-122
XSNG0000  0 0  2.7897E-05       /21 Sn-124
XZR00000  0 0  2.1828E-02       /22 Zr-90
XZR10000  0 0  4.7601E-03       /23 Zr-91
XZR20000  0 0  7.2759E-03       /24 Zr-92
XZR40000  0 0  7.3734E-03       /25 Zr-94
XZR60000  0 0  1.1879E-03       /26 Zr-96
MO03X04X  0 2  573.15  0.457      0.0  / 4 : Moderator Water
XH01H000  0 0  4.8507E-02    /1 H-1
XO060000  0 0  2.4254E-02    /2 O-16
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  12(1.790E-04) 6(0) 6(1.790E-04)  / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*        -10       -10      -10        -10      -10       -10
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
****** Input for PEACO option
0    / no plot
****** Enter one blank line to terminate repeatation on calculation cases
*------------------------------------------------------------------------------------------ 03 ----------------------------
FP04 : Thimble (A4)
UO2 pin cell problem in LWR next generation fuel benchmark (No burn-up)
1 1 1 1 2   1 4 3 -2 1   0 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
***** Input for PIJ (Collision Probability Method)
4 8 8 3 1   1 8 0 0 0   5 0 10 15 0   0 45 0         / Pij Control
0 50 50 5 5 5 -1  0.0001 0.00001 0.001 1.0 10. 0.5  / PIJ Block-2
1 1 1 2 3 3 3 3  /  R-S
3(1)             /  X-R
1 2 3          /  M-R
0.0  0.226  0.320  0.392  0.400  0.457  0.544  0.619  0.686    / RX (menggunakan P/D 1.5)
****** Input for material specification*****************************
3 / NMAT
FU04X01X  0 2  573.15  1.123    0.0  / 1 : Tabung Instrumen
XH01H000  0 0  4.8507E-02    /1 H-1
XO060000  0 0  2.4254E-02    /2 O-16
CL04X03X  0 25  598.15  0.081     0.0  / 2 : Cladding Zirconium-Alloy
XCR00000  0 0  3.2962E-06       /1 Cr-50
XCR20000  0 0  6.3564E-05       /2 Cr-52
XCR30000  0 0  7.2076E-06       /3 Cr-53
XCR40000  0 0  1.7941E-06       /4 Cr-54
XFE40000  0 0  8.6698E-06       /5 Fe-54
XFE60000  0 0  1.3610E-04       /6 Fe-56
XFE70000  0 0  3.1431E-06       /7 Fe-57
XFE80000  0 0  4.1829E-07       /8 Fe-58
XO060000  0 0  3.0744E-04    /9 O-16
XO070000  0 0  1.1680E-07    /10 O-17
*XO080000  0 0  6.1648E-07    /11 O-18
XSN20000  0 0  4.6735E-06       /12 Sn-112
XSN40000  0 0  3.1799E-06       /13 Sn-114
XSN50000  0 0  1.6381E-06       /14 Sn-115
XSN60000  0 0  7.0055E-05       /15 Sn-116
XSN70000  0 0  3.7003E-05       /16 Sn-117
XSN80000  0 0  1.1669E-04       /17 Sn-118
XSN90000  0 0  4.1387E-05       /18 Sn-119
XSNC0000  0 0  1.5697E-04       /19 Sn-120
XSNE0000  0 0  2.2308E-05       /20 Sn-122
XSNG0000  0 0  2.7897E-05       /21 Sn-124
XZR00000  0 0  2.1828E-02       /22 Zr-90
XZR10000  0 0  4.7601E-03       /23 Zr-91
XZR20000  0 0  7.2759E-03       /24 Zr-92
XZR40000  0 0  7.3734E-03       /25 Zr-94
XZR60000  0 0  1.1879E-03       /26 Zr-96
MO04X03X  0 2  573.15  0.168      0.0  / 3 : Moderator Water
XH01H000  0 0  4.8507E-02    /1 H-1
XO060000  0 0  2.4254E-02    /2 O-16
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  12(1.790E-04) 6(0) 6(1.790E-04)  / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*        -10       -10      -10        -10      -10       -10
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
****** Input for PEACO option
0    / no plot
****** Enter one blank line to terminate repeatation on calculation cases
*------------------------------------------------------------------------------------------ 04 ----------------------------
FP05 : Thimble (A4)
UO2 pin cell problem in LWR next generation fuel benchmark (No burn-up)
1 1 1 1 2   1 4 3 -2 1   0 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
***** Input for PIJ (Collision Probability Method)
4 8 8 5 1   1 8 0 0 0   5 0 10 15 0   0 45 0         / Pij Control
0 50 50 5 5 5 -1  0.0001 0.00001 0.001 1.0 10. 0.5  / PIJ Block-2
1 1 2 3 3 4 5 5 5  /  R-S
5(1)             /  X-R
1 2 3 4 5           /  M-R
0.0  0.226  0.320  0.392  0.400  0.457  0.544  0.619  0.686    / RX (menggunakan P/D 1.5)
****** Input for material specification*****************************
5 / NMAT
FU05X01X  0 6  573.15  1.123    0.0  / 1 : Air
*XAR00000  0 0  7.8730E-09    /1 Ar-36
*XAR80000  0 0  1.4844E-09    /2 Ar-38
XAR00000  0 0  2.3506E-06    /3 Ar-40
XC020000  0 0  6.7539E-08    /4 C-12
*XC030000  0 0  7.5658E-10    /5 C-13
XN040000  0 0  1.9680E-04    /6 N-14
XN050000  0 0  7.2354E-07    /7 N-15
XO060000  0 0  5.2866E-05    /8 O-16
XO070000  0 0  2.0084E-08    /9 O-17
*XO080000  0 0  1.0601E-07    /10 O-18
CL05X03X  0 25  598.15  0.081     0.0  / 2 : Cladding Zirconium-Alloy
XCR00000  0 0  3.2962E-06       /1 Cr-50
XCR20000  0 0  6.3564E-05       /2 Cr-52
XCR30000  0 0  7.2076E-06       /3 Cr-53
XCR40000  0 0  1.7941E-06       /4 Cr-54
XFE40000  0 0  8.6698E-06       /5 Fe-54
XFE60000  0 0  1.3610E-04       /6 Fe-56
XFE70000  0 0  3.1431E-06       /7 Fe-57
XFE80000  0 0  4.1829E-07       /8 Fe-58
XO060000  0 0  3.0744E-04    /9 O-16
XO070000  0 0  1.1680E-07    /10 O-17
*XO080000  0 0  6.1648E-07    /11 O-18
XSN20000  0 0  4.6735E-06       /12 Sn-112
XSN40000  0 0  3.1799E-06       /13 Sn-114
XSN50000  0 0  1.6381E-06       /14 Sn-115
XSN60000  0 0  7.0055E-05       /15 Sn-116
XSN70000  0 0  3.7003E-05       /16 Sn-117
XSN80000  0 0  1.1669E-04       /17 Sn-118
XSN90000  0 0  4.1387E-05       /18 Sn-119
XSNC0000  0 0  1.5697E-04       /19 Sn-120
XSNE0000  0 0  2.2308E-05       /20 Sn-122
XSNG0000  0 0  2.7897E-05       /21 Sn-124
XZR00000  0 0  2.1828E-02       /22 Zr-90
XZR10000  0 0  4.7601E-03       /23 Zr-91
XZR20000  0 0  7.2759E-03       /24 Zr-92
XZR40000  0 0  7.3734E-03       /25 Zr-94
XZR60000  0 0  1.1879E-03       /26 Zr-96
WT05X03X  0 2  573.15  0.168      0.0  / 3 : Moderator Water
XH01H000  0 0  4.8507E-02    /1 H-1
XO060000  0 0  2.4254E-02    /2 O-16
CL15X03X  0 25  598.15  0.081     0.0  / 2 : Cladding Zirconium-Alloy
XCR00000  0 0  3.2962E-06       /1 Cr-50
XCR20000  0 0  6.3564E-05       /2 Cr-52
XCR30000  0 0  7.2076E-06       /3 Cr-53
XCR40000  0 0  1.7941E-06       /4 Cr-54
XFE40000  0 0  8.6698E-06       /5 Fe-54
XFE60000  0 0  1.3610E-04       /6 Fe-56
XFE70000  0 0  3.1431E-06       /7 Fe-57
XFE80000  0 0  4.1829E-07       /8 Fe-58
XO060000  0 0  3.0744E-04    /9 O-16
XO070000  0 0  1.1680E-07    /10 O-17
*XO080000  0 0  6.1648E-07    /11 O-18
XSN20000  0 0  4.6735E-06       /12 Sn-112
XSN40000  0 0  3.1799E-06       /13 Sn-114
XSN50000  0 0  1.6381E-06       /14 Sn-115
XSN60000  0 0  7.0055E-05       /15 Sn-116
XSN70000  0 0  3.7003E-05       /16 Sn-117
XSN80000  0 0  1.1669E-04       /17 Sn-118
XSN90000  0 0  4.1387E-05       /18 Sn-119
XSNC0000  0 0  1.5697E-04       /19 Sn-120
XSNE0000  0 0  2.2308E-05       /20 Sn-122
XSNG0000  0 0  2.7897E-05       /21 Sn-124
XZR00000  0 0  2.1828E-02       /22 Zr-90
XZR10000  0 0  4.7601E-03       /23 Zr-91
XZR20000  0 0  7.2759E-03       /24 Zr-92
XZR40000  0 0  7.3734E-03       /25 Zr-94
XZR60000  0 0  1.1879E-03       /26 Zr-96
MO05X03X  0 2  573.15  0.168      0.0  / 3 : Moderator Water
XH01H000  0 0  4.8507E-02    /1 H-1
XO060000  0 0  2.4254E-02    /2 O-16
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  12(1.790E-04) 6(0) 6(1.790E-04)  / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*        -10       -10      -10        -10      -10       -10
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
****** Input for PEACO option
0    / no plot
****** Enter one blank line to terminate repeatation on calculation cases
*------------------------------------------------------------------------------------------ 04 ----------------------------
AS01 
1/4 perangkat bahan bakar dengan bahan bakar pengayaan 1.6%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL ASSEMBLY
1.0E-20  /Buckling
16 81 7 7 1    0 9 9 0 0   5 0 6 23 0   0 45 1         / Pij Control AS
0 100 100 5 5   5 -1  0.0001  0.00001  0.001  1.0 10. 0.5 /
1 2 2 3 2 2 3 2 2
4 5 5 5 5 5 5 5 5
4 5 5 5 5 5 5 5 5
7 5 5 6 5 5 6 5 5
4 5 5 5 5 5 5 5 5
4 5 5 5 5 6 5 5 5
7 5 5 6 5 5 5 5 5
4 5 5 5 5 5 5 5 5
4 5 5 5 5 5 5 5 5  / T-R, I-tube: 1; G-tube: 3,6,7; fuel: 2,4,5
7(1)  /R-R
3 1 2 1 1 2 2  / M-R
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / RX, sesuai pitch 1,25984 cm dari BEAVRS, ukuran RX/TY melebihi panjang 1/2 FA sedikit tapi ini perlu agar geometri tetap homogen dan simulasi tetap valid
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / TY
31 3 1 / Plot Geometry
3 / NMAT
FP01A010 0 0 0.0 0.0 0.0 / 1.6% U
FP04A010 0 0 0.0 0.0 0.0 / Guide-tube
FP05A010 0 0 0.0 0.0 0.0 / Instrument-tube
****** Enter one blank line to terminate repeatation on calculation cases
*------------------------------------------------------------------------------------------ 01 ----------------------------
AS02 
1/4 perangkat bahan bakar dengan bahan bakar pengayaan 2.4%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL ASSEMBLY
1.0E-20  /Buckling
16 81 7 7 1    0 9 9 0 0   5 0 6 23 0   0 45 1         / Pij Control AS
0 100 100 5 5   5 -1  0.0001  0.00001  0.001  1.0 10. 0.5 /
1 2 2 3 2 2 3 2 2
4 5 5 5 5 5 5 5 5
4 5 5 5 5 5 5 5 5
7 5 5 6 5 5 6 5 5
4 5 5 5 5 5 5 5 5
4 5 5 5 5 6 5 5 5
7 5 5 6 5 5 5 5 5
4 5 5 5 5 5 5 5 5
4 5 5 5 5 5 5 5 5  / T-R, I-tube: 1; G-tube: 3,6,7; fuel: 2,4,5
7(1)  /R-R
3 1 2 1 1 2 2  / M-R
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / RX, sesuai pitch 1,25984 cm dari BEAVRS, ukuran RX/TY melebihi panjang 1/2 FA sedikit tapi ini perlu agar geometri tetap homogen dan simulasi tetap valid
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / TY
31 3 1 / Plot Geometry
3 / NMAT
FP02A010 0 0 0.0 0.0 0.0 / 2.4% U
FP04A010 0 0 0.0 0.0 0.0 / Guide-tube
FP05A010 0 0 0.0 0.0 0.0 / Instrument-tube
****** Enter one blank line to terminate repeatation on calculation cases
*------------------------------------------------------------------------------------------ 02 ----------------------------
AS03 
1/4 perangkat bahan bakar dengan bahan bakar pengayaan 2.4%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL ASSEMBLY
1.0E-20  /Buckling
16 81 7 7 1    0 9 9 0 0   5 0 6 23 0   0 45 1         / Pij Control AS
0 100 100 5 5   5 -1  0.0001  0.00001  0.001  1.0 10. 0.5 /
1 2 2 3 2 2 3 2 2
4 5 5 5 5 5 5 5 5
4 5 5 5 5 5 5 5 5
7 5 5 6 5 5 6 5 5
4 5 5 5 5 5 5 5 5
4 5 5 5 5 6 5 5 5
7 5 5 6 5 5 5 5 5
4 5 5 5 5 5 5 5 5
4 5 5 5 5 5 5 5 5  / T-R, I-tube: 1; G-tube: 3,6,7; fuel: 2,4,5
7(1)  /R-R
3 1 2 1 1 2 2  / M-R
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / RX, sesuai pitch 1,25984 cm dari BEAVRS, ukuran RX/TY melebihi panjang 1/2 FA sedikit tapi ini perlu agar geometri tetap homogen dan simulasi tetap valid
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / TY
31 3 1 / Plot Geometry
3 / NMAT
FP03A010 0 0 0.0 0.0 0.0 / 3.1% U
FP04A010 0 0 0.0 0.0 0.0 / Guide-tube
FP05A010 0 0 0.0 0.0 0.0 / Instrument-tube
****** Enter one blank line to terminate repeatation on calculation cases

"@

$Input | &"$LM" >> $OUTLST

#
#========  Remove scratch files ================================================
#

cd "$SRAC_DIR"
rm -r "$WKDR"

#
#========  Remove PDS files if you don't keep them =============================
#

rm -r "$PDS_DIR"

#
#  rm -r $PDS_DIR/UFAST
#  rm -r $PDS_DIR/UTHERMAL
#  rm -r $PDS_DIR/UMCROSS
#  rm -r $PDS_DIR/MACROWRK
#  rm -r $PDS_DIR/MACRO
#  rm -r $PDS_DIR/FLUX
#  rm -r $PDS_DIR/MICREF
