@echo off

mkdir "bak"
mkdir "bak\cxi0"

if not exist "bak\cxi0\exefs.bin" (copy cci\cxi0\exefs.bin bak\cxi0\exefs.bin)
if not exist "bak\cxi0\romfs.bin" (copy cci\cxi0\romfs.bin bak\cxi0\romfs.bin)
if not exist "bak\0.cxi" (copy cci\0.cxi bak\0.cxi)

tools\3dstool -cvtf exefs cci\cxi0\exefs.bin --header cci\cxi0\exefs\ncchheader.bin --exefs-dir cci\cxi0\exefs

tools\3dstool -cvtf romfs cci\cxi0\romfs.bin --romfs-dir cci\cxi0\romfs

tools\3dstool -cvtf cxi cci\0.cxi --header cci\cxi0\ncchheader.bin --exh cci\cxi0\exh.bin --logo cci\cxi0\logo.bin --plain cci\cxi0\plain.bin --exefs cci\cxi0\exefs.bin --romfs cci\cxi0\romfs.bin

tools\3dstool -cvt01267f cci cci\0.cxi cci\1.cfa cci\2.cfa cci\6.cfa cci\7.cfa nokey.3ds --header cci\ncsdheader.bin