@echo off
tools\ncchinfo_gen.exe %1
move tools\ncchinfo.bin ncchinfo.bin
tools\ncchinfo_padgen_requires_keyxs.exe ncchinfo.bin
del ncchinfo.bin
MD cci

tools\3dstool -xvt01267f cci cci\0.cxi cci\1.cfa cci\2.cfa cci\6.cfa cci\7.cfa %1 --header cci\ncsdheader.bin
MD cci\cxi0
rename *.Main.romfs.xorpad         Main.romfs.xorpad
rename *.Main.exefs_norm.xorpad    Main.exefs_norm.xorpad
rename *.Main.exheader.xorpad      Main.exheader.xorpad
rename *.Manual.romfs.xorpad       Manual.romfs.xorpad
rename *.UpdateData.romfs.xorpad   UpdateData.romfs.xorpad
rename *.DownloadPlay.romfs.xorpad DownloadPlay.romfs.xorpad
rename *.Main.exefs_7x.xorpad      Main.exefs_7x.xorpad
rename *.Partition7.romfs.xorpad   Partition7.romfs.xorpad
tools\3dstool -xvtf cxi cci\0.cxi --header cci\cxi0\ncchheader.bin --exh cci\cxi0\exh.bin --logo cci\cxi0\logo.bin --plain cci\cxi0\plain.bin --exefs cci\cxi0\exefs.bin --romfs cci\cxi0\romfs.bin --exh-xor Main.exheader.xorpad --romfs-xor Main.romfs.xorpad
move cci\cxi0\exefs.bin exefs.bin
tools\MEX.exe exefs.bin Main.exefs_norm.xorpad Main.exefs_7x.xorpad exefs.xorpad
rename Main.exefs_norm.xorpad exefs.xorpad
tools\padxorer.exe exefs.bin exefs.xorpad
del exefs.bin
rename decrypted_exefs.bin exefs.bin
move exefs.bin cci\cxi0\exefs.bin
MD cci\cfa1
MD cci\cfa2
MD cci\cfa6
MD cci\cfa7
tools\3dstool -xvtf cfa cci\1.cfa --header cci\cfa1\ncchheader.bin --romfs cci\cfa1\romfs.bin --romfs-xor Manual.romfs.xorpad
tools\3dstool -xvtf cfa cci\2.cfa --header cci\cfa2\ncchheader.bin --romfs cci\cfa2\romfs.bin --romfs-xor DownloadPlay.romfs.xorpad
tools\3dstool -xvtf cfa cci\6.cfa --header cci\cfa6\ncchheader.bin --romfs cci\cfa6\romfs.bin --romfs-xor Partition7.romfs.xorpad
tools\3dstool -xvtf cfa cci\7.cfa --header cci\cfa7\ncchheader.bin --romfs cci\cfa7\romfs.bin --romfs-xor UpdateData.romfs.xorpad
tools\3dstool -xvtf romfs cci\cxi0\romfs.bin --romfs-dir cci\cxi0\romfs
tools\3dstool -xvtfu exefs cci\cxi0\exefs.bin --exefs-dir cci\cxi0\exefs --header cci\cxi0\exefs\ncchheader.bin
tools\3dstool -xvtf romfs cci\cfa1\romfs.bin --romfs-dir cci\cfa1\romfs
tools\3dstool -xvtf romfs cci\cfa2\romfs.bin --romfs-dir cci\cfa2\romfs
tools\3dstool -xvtf romfs cci\cfa6\romfs.bin --romfs-dir cci\cfa6\romfs
tools\3dstool -xvtf romfs cci\cfa7\romfs.bin --romfs-dir cci\cfa7\romfs
del Main.romfs.xorpad
del Main.exefs_norm.xorpad
del Main.exheader.xorpad
del Manual.romfs.xorpad
del UpdateData.romfs.xorpad
del DownloadPlay.romfs.xorpad
del Main.exefs_7x.xorpad
del Partition7.romfs.xorpad
del exefs.xorpad