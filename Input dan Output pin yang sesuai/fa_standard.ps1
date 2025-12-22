#
#  <<  run SRAC  >>
#
#===============================================================================
#  fa_standard.ps1 : Test problem to check SRAC installation
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
CLADX02X  0 5  598.15  0.1570727426    0.0  / 3 : Cladding Zirconium-Alloy, berdasarkan perhitungan, tidak mengikuti data Zircaloy-4 BEAVR karena tidak dicantum elemen natural spesifik ZRN, SNN, dst.
XZRN0000  2 0  4.2540E-02       /1 ZRN
XSNN0000  2 0  4.8253E-04       /2 SNN
XFEN0000  2 0  1.4854E-04       /3 FEN
XCRN0000  2 0  7.5986E-05       /4 CRN
XHFN0000  2 0  2.2133E-06
MODEX03X  0 2  573.15  0.1092814516      0.0  / 4 : Moderator Water
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
AS01
1/4 perangkat bahan bakar dengan bahan bakar pengayaan 1.6%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL
1.0E-20 / BUCKLING
16 81 4 4 1     0 9 9 0 0  5 0 6 23 0  0 45 1 / PIJ CONTROL, digunakan pembagian subregion 9x9 untuk 1/4 perangkat bahan bakar 17x17, kol. 1 = 16 untuk geometri segiempat, kol 2: 81 untuk jumlah subregion, kol. 3 dan 4 = 4 berdasarkan T-region dan R-region, kol. 6 = 0 untuk isotropic reflection dipinggir, kol. 7 dan 8 = 9x9, kol. 18 = 1 untuk plot
0 100 100 5 5     5 -1 0.0001 0.00001 0.001 1.0 10 0.5 /
1 6 6 2 6 6 2 6 6
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5
3 5 5 4 5 5 4 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 4 5 5 5
3 5 5 4 5 5 5 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5 / T-R, thimble: 1,2,3,4; fuel: 5,6,7
7(1) / R-R
2 2 2 2 1 1 1 / M-R
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / RX, sesuai pitch 1,25984 cm dari BEAVRS, ukuran RX/TY melebihi panjang 1/2 FA sedikit tapi ini perlu agar geometri tetap homogen dan simulasi tetap valid
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / TY
31 3 1 / Plot Geometry
2 / NMAT
FP01A010 0 0 0.0 0.0 0.0 / 1.6% U
THIMA010 0 0 0.0 0.0 0.0 / Thimble
************************************************************************
AS02
1/4 perangkat bahan bakar dengan bahan bakar pengayaan 2.4%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL
1.0E-20 / BUCKLING
16 81 4 4 1     0 9 9 0 0  5 0 6 23 0  0 45 1 / PIJ CONTROL, digunakan pembagian subregion 9x9 untuk 1/4 perangkat bahan bakar 17x17, kol. 1 = 16 untuk geometri segiempat, kol 2: 81 untuk jumlah subregion, kol. 3 dan 4 = 4 berdasarkan T-region dan R-region, kol. 6 = 0 untuk isotropic reflection dipinggir, kol. 7 dan 8 = 9x9, kol. 18 = 1 untuk plot
0 100 100 5 5     5 -1 0.0001 0.00001 0.001 1.0 10 0.5 /
1 6 6 2 6 6 2 6 6
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5
3 5 5 4 5 5 4 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 4 5 5 5
3 5 5 4 5 5 5 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5 / T-R, thimble: 1,2,3,4; fuel: 5,6,7
7(1) / R-R
2 2 2 2 1 1 1 / M-R
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / RX, sesuai pitch 1,25984 cm dari BEAVRS, ukuran RX/TY melebihi panjang 1/2 FA sedikit tapi ini perlu agar geometri tetap homogen dan simulasi tetap valid
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / TY
31 3 1 / Plot Geometry
2 / NMAT
FP02A010 0 0 0.0 0.0 0.0 / 2.4% U
THIMA010 0 0 0.0 0.0 0.0 / Thimble
************************************************************************
AS03
1/4 perangkat bahan bakar dengan bahan bakar pengayaan 3.1%
1 0 0 1 0  1 0 0 0 1  0 1 0 0 2  0 1 0 0 0 / SRAC CONTROL
1.0E-20 / BUCKLING
16 81 4 4 1     0 9 9 0 0  5 0 6 23 0  0 45 1 / PIJ CONTROL, digunakan pembagian subregion 9x9 untuk 1/4 perangkat bahan bakar 17x17, kol. 1 = 16 untuk geometri segiempat, kol 2: 81 untuk jumlah subregion, kol. 3 dan 4 = 4 berdasarkan T-region dan R-region, kol. 6 = 0 untuk isotropic reflection dipinggir, kol. 7 dan 8 = 9x9, kol. 18 = 1 untuk plot
0 100 100 5 5     5 -1 0.0001 0.00001 0.001 1.0 10 0.5 /
1 6 6 2 6 6 2 6 6
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5
3 5 5 4 5 5 4 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 4 5 5 5
3 5 5 4 5 5 5 5 5
7 5 5 5 5 5 5 5 5
7 5 5 5 5 5 5 5 5 / T-R, thimble: 1,2,3,4; fuel: 5,6,7
7(1) / R-R
2 2 2 2 1 1 1 / M-R
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / RX, sesuai pitch 1,25984 cm dari BEAVRS, ukuran RX/TY melebihi panjang 1/2 FA sedikit tapi ini perlu agar geometri tetap homogen dan simulasi tetap valid
0.0 1.25984 2.51968 3.77952 5.03936 6.2992 7.55904 8.81888 10.07872 11.33856 / TY
31 3 1 / Plot Geometry
2 / NMAT
FP03A010 0 0 0.0 0.0 0.0 / 3.1% U
THIMA010 0 0 0.0 0.0 0.0 / Thimble
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