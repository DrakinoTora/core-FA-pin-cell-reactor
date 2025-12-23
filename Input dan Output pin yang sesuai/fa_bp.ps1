#
#  <<  run SRAC  >>
#
#===============================================================================
#  fa_bp.ps1 : Test problem to check SRAC installation
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
$Case = "fa_bp"
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
FP01 : Case name (A4)
Bahan bakar dengan pengkayaan 1.6%
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
$PDS_DIR/UFAST      New  Core
$PDS_DIR/UTHERMAL   N        C
$PDS_DIR/UMCROSS    N        C
$PDS_DIR/MACROWRK   N        C
$PDS_DIR/MACRO      N        C
$PDS_DIR/FLUX       N        C
$PDS_DIR/MICREF     N        C
************************************************************************
62 45  3 3 /  107 group => 6 group
62(1)      /  Energy group structure suggested for LWR analyses
45(1)      /
20 21 21  / Fast 62 group
15 15 15  / Thermal 45 group
***** Enter one blank line after input for energy group structure

***** Input for PIJ (Collision Probability Method)
4 8 8 4 1   1 8 0 0 0   5 0 10 15 0   0 45 0         / Pij Control
0 50 50 5 5 5 -1  0.0001 0.00001 0.001 1.0 10. 0.5  /
1 1 1 2 3 4 4 4  /  R-S
4(1)             /  X-R
1 2 3 4          /  M-R
0.0  0.226  0.320  0.392  0.400  0.457  0.515  0.572  0.630 /  RX
****** Input for material specification
4 / NMAT
FUELX01X  0 3  1073.15  0.78436    0.0  / 1 : UO2 Fuel, kol.3 (NISO) = 3 nuklida, kol.4 (TEMP) = suhu sesuai soal, kol. 5 (XL) = chord length dari perhitungan manual  
XU050000  2 0  3.7503E-04    /1 U-235, Kolom 2 (IRES) bernilai 2 karena berupa nuklida resonan [p. 126]
XU080000  2 0  2.2625E-02    /2 U-238, nuklida resonan
XO060000  0 0  4.5897E-02    /3 O-16, bukan nuklida resonan, kolom IRES bernilai 0 [p.126]
HELIX02X  0 1  773.15  0.03117     0.0  / 2 : Gap Helium
XHE40000  0 0  1.8737E-04       /1 Helium-4
CLADX03X  0 5  598.15  0.21431    0.0  / 3 : Cladding Zirconium-Alloy, berdasarkan perhitungan, tidak mengikuti data Zircaloy-4 BEAVR karena tidak dicantum elemen natural spesifik ZRN, SNN, dst.
XZRN0000  2 0  4.2540E-02       /1 ZRN
XSNN0000  2 0  4.8253E-04       /2 SNN
XFEN0000  2 0  1.4854E-04       /3 FEN
XCRN0000  2 0  7.5986E-05       /4 CRN
XHFN0000  2 0  2.2133E-06       /5 HFN
MODEX04X  0 2  573.15  0.56916      0.0  / 4 : Moderator Water
XH01H000  0 0  4.85485E-02    /1 H1
XO060000  0 0  2.42742E-02     /2
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
************************
0
************************************************************************
FP02 : Case name (A4)
Bahan bakar dengan pengayaan 2.4%
1 1 1 1 2   1 4 3 -2 1   1 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
****** Input for material specification
4 / NMAT
FUELX01X  0 3  1073.15  0.78436    0.0  / 1 : UO2 Fuel, kol.3 (NISO) = 3 nuklida, kol.4 (TEMP) = suhu sesuai soal, kol. 5 (XL) = chord length dari perhitungan manual  
XU050000  2 0  5.5814E-04    /1 U-235, Kolom 2 (IRES) bernilai 2 karena berupa nuklida resonan [p. 126]
XU080000  2 0  2.2407E-02      /2
XO060000  0 0  4.5830E-02      /3
HELIX02X  0 1  773.15  0.03117     0.0  / 2 : Gap Helium
XHE40000  0 0  1.8737E-04       /1 Helium-4
CLADX03X  0 5  598.15  0.21431    0.0  / 3 : Cladding Zirconium-Alloy, berdasarkan perhitungan, tidak mengikuti data Zircaloy-4 BEAVR karena tidak dicantum elemen natural spesifik ZRN, SNN, dst.
XZRN0000  2 0  4.2540E-02       /1 ZRN
XSNN0000  2 0  4.8253E-04       /2 SNN
XFEN0000  2 0  1.4854E-04       /3 FEN
XCRN0000  2 0  7.5986E-05       /4 CRN
XHFN0000  2 0  2.2133E-06       /5 HFN
MODEX04X  0 2  573.15  0.56916      0.0  / 4 : Moderator Water
XH01H000  0 0  4.85485E-02    /1 H1
XO060000  0 0  2.42742E-02     /2
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
************************
0
************************************************************************
FP03 : Case name (A4)
Bahan bakar dengan pengayaan 3.1%
1 1 1 1 2   1 4 3 -2 1   1 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
****** Input for material specification
4 / NMAT
FUELX01X  0 3  1073.15  0.78436    0.0  / 1 : UO2 Fuel, kol.3 (NISO) = 3 nuklida, kol.4 (TEMP) = suhu sesuai soal, kol. 5 (XL) = chord length dari perhitungan manual  
XU050000  2 0  7.2175E-04    /1 U-235, Kolom 2 (IRES) bernilai 2 karena berupa nuklida resonan [p. 126]
XU080000  2 0  2.2253E-02      /2
XO060000  0 0  4.5853E-02      /3
HELIX02X  0 1  773.15  0.03117     0.0  / 2 : Gap Helium
XHE40000  0 0  1.8737E-04       /1 Helium-4
CLADX03X  0 5  598.15  0.21431    0.0  / 3 : Cladding Zirconium-Alloy, berdasarkan perhitungan, tidak mengikuti data Zircaloy-4 BEAVR karena tidak dicantum elemen natural spesifik ZRN, SNN, dst.
XZRN0000  2 0  4.2540E-02       /1 ZRN
XSNN0000  2 0  4.8253E-04       /2 SNN
XFEN0000  2 0  1.4854E-04       /3 FEN
XCRN0000  2 0  7.5986E-05       /4 CRN
XHFN0000  2 0  2.2133E-06       /5 HFN
MODEX04X  0 2  573.15  0.56916      0.0  / 4 : Moderator Water
XH01H000  0 0  4.85485E-02    /1 H1
XO060000  0 0  2.42742E-02     /2
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
************************
0
************************************************************************
THIM : Case name (A4)
Tabung instrumen dan batang kendali diisi dengan air
1 1 1 1 2   1 4 3 -2 1   0 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
***** Input for PIJ (Collision Probability Method)
4 7 7 3 1   1 7 0 0 0   5 0 10 15 0   0 45 0         / Pij Control
0 50 50 5 5 5 -1  0.0001 0.00001 0.001 1.0 10. 0.5  /
1 1 1 2 3 3 3  /  R-S
3(1)           /  X-R
1 2 3          /  M-R
0.0  0.226  0.320  0.561  0.602  0.611  0.621  0.63  / RX
****** Input for material specification
3 / NMAT
WAT0X01X  0 2  573.15  1.12268      0.0  / 1 : H2O dalam tabung
XH01H000  0 0  4.85485E-02    /1 H1
XO060000  0 0  2.42742E-02     /2
CLADX03X  0 5  598.15  0.1570727426    0.0  / 3 : Cladding Zirconium-Alloy, berdasarkan perhitungan, tidak mengikuti data Zircaloy-4 BEAVR karena tidak dicantum elemen natural spesifik ZRN, SNN, dst.
XZRN0000  2 0  4.2540E-02       /1 ZRN
XSNN0000  2 0  4.8253E-04       /2 SNN
XFEN0000  2 0  1.4854E-04       /3 FEN
XCRN0000  2 0  7.5986E-05       /4 CRN
XHFN0000  2 0  2.2133E-06
MODEX04X  0 2  573.15  0.1092814516      0.0  / 4 : Moderator Water
XH01H000  0 0  4.85485E-02    /1 H1
XO060000  0 0  2.42742E-02     /2
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
************************
0
************************************************************************
BPOI : Case name (A4)
Tabung instrumen dan batang kendali diisi dengan air
1 1 1 1 2   1 4 3 -2 1   0 0 0 0 1   2 1 0 0 0 / SRAC CONTROL
1.000E-20 / Geometrical buckling for P1/B1 calculation
***** Input for PIJ (Collision Probability Method)
4 9 9 3 1   1 9 0 0 0   5 0 10 15 0   0 45 0         / Pij Control
0 50 50 5 5 5 -1  0.0001 0.00001 0.001 1.0 10. 0.5  /
1 2 3 4 5 6 7 8 8  /  R-S
8(1)           /  X-R
1 2 3 4 5 6 7 8          /  M-R
0.0  0.214  0.23051  0.2413  0.42672  0.43688  0.48387  0.56134  0.602  0.616  0.63  / RX, masing-masing bagian 1 subregion, kecuali moderator/H2O luar dengan 2 subregion
****** Input for material specification
9 / NMAT
UDA0X01X  0 2  573.15  0.428      0.0  / 1 : Udara dalam tabung
XAR60000  0 0  7.8730E-09    /1 Ar36
XAR80000  0 0  1.4844E-09     /2 Ar38
XAR00000  0 0  2.3506E-06    /3 Ar40
XC020000  0 0  6.7539E-08     /4 C12
XC030000  0 0  7.5658E-10    /5 C13
XN040000  0 0  1.9680E-04     /6 N14
XN050000  0 0  7.2354E-07    /7 N15
XO060000  0 0  5.2866E-05     /8 O16
XO070000  0 0  2.0084E-08    /9 O17
XO080000  0 0  1.0601E-02     /10 O18
S304X02X  0 5  598.15  0.06367498243    0.0  / 2 : Cladding Stainless Steel 304
XCR00000  2 0  7.6778E-02       /1 CR
XCR20000  2 0  1.4806E-04       /2 CR
XCR30000  2 0  1.6789E-04       /3 CR
XCR40000  2 0  4.1791E-05       /4 CR
XFE60000  2 0  3.4620E-06       /5 FE
XFE70000  2 0  5.4345E-02       /6 FE
XFE80000  2 0  1.2551E-04       /7 FE
XMN50000  2 0  1.6703E-04       /8 MN
XNI80000  2 0  1.7604E-05       /9 NI
XNI00000  2 0  5.6089E-06       /10 NI
XNI10000  2 0  2.1605E-02       /11 NI
XNI20000  2 0  9.3917E-04       /12 NI
XNI40000  2 0  2.9945E-04       /13 NI
XSI80000  2 0  4.8381E-05       /14 SI
XSI90000  2 0  4.8381E-06       /15 SI
XSI00000  2 0  3.1893E-04       /17 SI
HEL1X03X  0 1  773.15  0.04219502611     0.0  / 3 : Gap Helium SS304-B2O4
XHE40000  0 0  1.8737E-04       /1 Helium-4
B2O3X04X  0 1  773.15  0.5805411905     0.0  / 4 : Borosilicate Glass dengan densitas 2.26 g/cc dengan fraksi massa B2O3 sebesar 12.5 wt%
XALN0000  0 0  1.7352e-03    /1 AL
XB000000  0 0  9.72606E-04     /2 B-10
XB010000  0 0  3.91486E-03    /3 B-11
XO060000  0 0  7.31361E-03     /4 O-16
XO070000  0 0  2.93248E-06    /5 O-17
XO080000  0 0  1.46624E-05     /6 O-18
XSI80000  0 0  1.6926E-02    /7 SI-28
XSI90000  0 0  8.5944E-04     /8 SI-29
XSI00000  0 0  5.6654E-04       / 9 SI-30
HEL2X05X  0 1  773.15  0.04016744186     0.0  / 5 : Gap Helium B2O4-SS304
XHE40000  0 0  1.8737E-04       /1 Helium-4
S304X06X  0 5  598.15  0.1788333333    0.0  / 2 : Cladding Stainless Steel 304
XCR00000  2 0  7.6778E-02       /1 CR
XCR20000  2 0  1.4806E-04       /2 CR
XCR30000  2 0  1.6789E-04       /3 CR
XCR40000  2 0  4.1791E-05       /4 CR
XFE60000  2 0  3.4620E-06       /5 FE
XFE70000  2 0  5.4345E-02       /6 FE
XFE80000  2 0  1.2551E-04       /7 FE
XMN50000  2 0  1.6703E-04       /8 MN
XNI80000  2 0  1.7604E-05       /9 NI
XNI00000  2 0  5.6089E-06       /10 NI
XNI10000  2 0  2.1605E-02       /11 NI
XNI20000  2 0  9.3917E-04       /12 NI
XNI40000  2 0  2.9945E-04       /13 NI
XSI80000  2 0  4.8381E-05       /14 SI
XSI90000  2 0  4.8381E-06       /15 SI
XSI00000  2 0  3.1893E-04       /17 SI
WAT0X07X  0 2  573.15  0.2884968778      0.0  / 7 : H2O bagian dalam Zircaloy
XH01H000  0 0  4.85485E-02    /1 H1
XO060000  0 0  2.42742E-02     /2
ZIRCX08X  0 5  598.15  0.1570727426    0.0  / 8 : Cladding Zirconium-Alloy, berdasarkan perhitungan, tidak mengikuti data Zircaloy-4 BEAVR karena tidak dicantum elemen natural spesifik ZRN, SNN, dst.
XZRN0000  2 0  4.2540E-02       /1 ZRN
XSNN0000  2 0  4.8253E-04       /2 SNN
XFEN0000  2 0  1.4854E-04       /3 FEN
XCRN0000  2 0  7.5986E-05       /4 CRN
XHFN0000  2 0  2.2133E-06       /5 HFN
MODEX09X  0 2  573.15  0.1095875543      0.0  / 9 : Moderator Water
XH01H000  0 0  4.85485E-02    /1 H1
XO060000  0 0  2.42742E-02     /2
****** Input for cell burn-up calculation (when IC20=1)
*  12 1 1 0 0  0 0 0 0 0  10(0)   / IBC
*  12(1.790E-04)   / Power level  (MWt/cm)
*  0.10E+03  1.00E+03  2.50E+03  5.00E+03  7.50E+03  1.00E+04
*  1.25E+04  1.50E+04  1.75E+04  2.00E+04  2.25E+04  2.50E+04
*  2.75E+04  3.00E+04  3.25E+04  3.50E+04  3.75E+04  4.00E+04
*  4.25E+04  4.50E+04  4.75E+04  5.00E+04  5.25E+04  5.50E+04
*  5.75E+04  6.00E+04  6.25E+04  6.50E+04  6.75E+04  7.00E+04
*  7.25E+04  /  keff calculation is not done at the last step 
************************
0
************************************************************************
AP01
1/4 perangkat bahan bakar berisi poison dengan bahan bakar pengayaan 1.6%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL
1.0E-20 / BUCKLING
16 81 4 4 1     0 9 9 0 0  5 0 6 23 0  0 45 1 / PIJ CONTROL, digunakan pembagian subregion 9x9 untuk 1/4 perangkat bahan bakar 17x17, kol. 1 = 16 untuk geometri segiempat, kol 2: 81 untuk jumlah subregion, kol. 3 dan 4 = 4 berdasarkan T-region dan R-region, kol. 6 = 0 untuk isotropic reflection dipinggir, kol. 7 dan 8 = 9x9, kol. 18 = 1 untuk plot
0 100 100 5 5     5 -1 0.0001 0.00001 0.001 1.0 10 0.5 /
1 6 6 2 6 6 2 6 6
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5
3 5 5 4 5 5 8 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 8 5 5 5
3 5 5 8 5 5 5 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5 / T-R, thimble: 1,2,3,4; fuel: 5,6,7; BP: 8
8(1) / R-R
2 2 2 2 1 1 1 3 / M-R
0.0 0.62992 1.88976 3.1496 4.40944 5.66928 6.92912 8.18896 9.4488 10.70864 / RX  
0.0 0.62992 1.88976 3.1496 4.40944 5.66928 6.92912 8.18896 9.4488 10.70864 / TY
31 3 1 / Plot Geometry
3 / NMAT
FP01A010 0 0 0.0 0.0 0.0 / 1.6% U
THIMA010 0 0 0.0 0.0 0.0 / Thimble
BPOIA010 0 0 0.0 0.0 0.0 / BP pin
************************************************************************
AP02
1/4 perangkat bahan bakar berisi poison dengan bahan bakar pengayaan 2.4%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL
1.0E-20 / BUCKLING
16 81 4 4 1     0 9 9 0 0  5 0 6 23 0  0 45 1 / PIJ CONTROL, digunakan pembagian subregion 9x9 untuk 1/4 perangkat bahan bakar 17x17, kol. 1 = 16 untuk geometri segiempat, kol 2: 81 untuk jumlah subregion, kol. 3 dan 4 = 4 berdasarkan T-region dan R-region, kol. 6 = 0 untuk isotropic reflection dipinggir, kol. 7 dan 8 = 9x9, kol. 18 = 1 untuk plot
0 100 100 5 5     5 -1 0.0001 0.00001 0.001 1.0 10 0.5 /
1 6 6 2 6 6 2 6 6
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5
3 5 5 4 5 5 8 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 8 5 5 5
3 5 5 8 5 5 5 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5 / T-R, thimble: 1,2,3,4; fuel: 5,6,7; BP: 8
8(1) / R-R
2 2 2 2 1 1 1 3 / M-R
0.0 0.62992 1.88976 3.1496 4.40944 5.66928 6.92912 8.18896 9.4488 10.70864 / RX  
0.0 0.62992 1.88976 3.1496 4.40944 5.66928 6.92912 8.18896 9.4488 10.70864 / TY
31 3 1 / Plot Geometry
3 / NMAT
FP02A010 0 0 0.0 0.0 0.0 / 2.4% U
THIMA010 0 0 0.0 0.0 0.0 / Thimble
BPOIA010 0 0 0.0 0.0 0.0 / BP pin
************************************************************************
AP03
1/4 perangkat bahan bakar berisi poison dengan bahan bakar pengayaan 3.1%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL
1.0E-20 / BUCKLING
16 81 4 4 1     0 9 9 0 0  5 0 6 23 0  0 45 1 / PIJ CONTROL, digunakan pembagian subregion 9x9 untuk 1/4 perangkat bahan bakar 17x17, kol. 1 = 16 untuk geometri segiempat, kol 2: 81 untuk jumlah subregion, kol. 3 dan 4 = 4 berdasarkan T-region dan R-region, kol. 6 = 0 untuk isotropic reflection dipinggir, kol. 7 dan 8 = 9x9, kol. 18 = 1 untuk plot
0 100 100 5 5     5 -1 0.0001 0.00001 0.001 1.0 10 0.5 /
1 6 6 2 6 6 2 6 6
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5
3 5 5 4 5 5 8 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 8 5 5 5
3 5 5 8 5 5 5 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5 / T-R, thimble: 1,2,3,4; fuel: 5,6,7; BP: 8
8(1) / R-R
2 2 2 2 1 1 1 3 / M-R
0.0 0.62992 1.88976 3.1496 4.40944 5.66928 6.92912 8.18896 9.4488 10.70864 / RX  
0.0 0.62992 1.88976 3.1496 4.40944 5.66928 6.92912 8.18896 9.4488 10.70864 / TY
31 3 1 / Plot Geometry
3 / NMAT
FP03A010 0 0 0.0 0.0 0.0 / 3.1% U
THIMA010 0 0 0.0 0.0 0.0 / Thimble
BPOIA010 0 0 0.0 0.0 0.0 / BP pin
************************************************************************
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