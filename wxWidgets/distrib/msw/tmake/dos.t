#!#############################################################################
#! File:    dos.t
#! Purpose: tmake template file from which makefile.dos is generated by running
#!          tmake -t dos wxwin.pro -o makefile.dos
#! Author:  Vadim Zeitlin
#! Created: 14.07.99
#! Version: $Id: dos.t 19898 2003-03-30 22:47:33Z JS $
#!#############################################################################
#${
    #! include the code which parses filelist.txt file and initializes
    #! %wxCommon, %wxGeneric and %wxMSW hashes.
    IncludeTemplate("filelist.t");

    #! now transform these hashes into $project tags
    foreach $file (sort keys %wxGeneric) {
        if ( $wxGeneric{$file} =~ /\b(PS|G|U)\b/ ) {
            #! Need this file too since it has wxGenericPageSetupDialog
            next unless $file =~ /^prntdlgg\./;
        }

        $file =~ s/cp?p?$/obj/;
        $project{"WXGENERICOBJS"} .= "\$(GENDIR)\\" . $file . " "
    }

    #! because we later search for " <filename> " in this string
    $project{"WXCOBJS"} = " ";

    foreach $file (sort keys %wxCommon) {
        #! socket files don't compile under Win16 currently
        next if $wxCommon{$file} =~ /\b(32|S)\b/;

        $isCFile = $file =~ /\.c$/;
        $file =~ s/cp?p?$/obj/;
        $obj = "\$(COMMDIR)\\" . $file . " ";
        #! $project{"WXCOMMONOBJS"} .= $obj;
        #! have to split lib in 2 halves because otherwise it's too big
        $project{$file =~ "^[a-o]" ? "WXCOMMONOBJS1" : "WXCOMMONOBJS2"} .= $obj;
        $project{"WXCOBJS"} .= $obj if $isCFile;
    }

    foreach $file (sort keys %wxMSW) {
        #! don't take files not appropriate for 16-bit Windows
        next if $wxMSW{$file} =~ /\b(32|O)\b/;

        $isCFile = $file =~ /\.c$/;
        $file =~ s/cp?p?$/obj/;
        $obj = "\$(MSWDIR)\\" . $file . " ";
        #! have to split lib in 2 halves because otherwise it's too big
        $project{$file =~ "^[a-o]" ? "WXMSWOBJS1" : "WXMSWOBJS2"} .= $obj;
        $project{"WXCOBJS"} .= $obj if $isCFile;
    }
#$}
# This file was automatically generated by tmake 
# DO NOT CHANGE THIS FILE, YOUR CHANGES WILL BE LOST! CHANGE DOS.T!

#
# File:     makefile.dos
# Author:   Julian Smart
# Created:  1997
# Updated:
# Copyright:(c) 1997, Julian Smart
#
# "%W% %G%"
#
# Makefile : Builds wxWindows library wx.lib for VC++ (16-bit)
# Arguments:
#
# FINAL=1 argument to nmake to build version with no debugging info.
#
!include <..\makemsc.env>

LIBTARGET=$(WXLIB)
DUMMYOBJ=dummy.obj

# Please set these according to the settings in wx_setup.h, so we can include
# the appropriate libraries in wx.lib

# This one overrides the others, to be consistent with the settings in wx_setup.h
MINIMAL_WXWINDOWS_SETUP=0

USE_CTL3D=1

!if "$(MINIMAL_WXWINDOWS_SETUP)" == "1"
USE_CTL3D=0
!endif

PERIPH_LIBS=
PERIPH_TARGET=
PERIPH_CLEAN_TARGET=

# !if "$(USE_CTL3D)" == "1"
# PERIPH_LIBS=d:\msdev\lib\ctl3d32.lib $(PERIPH_LIBS)
# !endif

# PNG and Zlib
PERIPH_TARGET=png zlib $(PERIPH_TARGET)
PERIPH_CLEAN_TARGET=clean_png clean_zlib $(PERIPH_CLEAN_TARGET)

GENDIR=..\generic
COMMDIR=..\common
OLEDIR=.\ole
MSWDIR=.

GENERICOBJS= #$ ExpandList("WXGENERICOBJS");

# we can't have all objects in one list because the library becomes too big
COMMONOBJS1 = \
		#$ ExpandList("WXCOMMONOBJS1");

COMMONOBJS2 = \
		#$ ExpandList("WXCOMMONOBJS2");

# we can't have all objects in one list because the library becomes too big
MSWOBJS1 = #$ ExpandList("WXMSWOBJS1");

MSWOBJS2 = #$ ExpandList("WXMSWOBJS2");

OBJECTS = $(COMMONOBJS1) $(COMMONOBJS2) $(GENERICOBJS) $(MSWOBJS1) $(MSWOBJS2)

# Normal, static library
all:    $(DUMMYOBJ) $(WXDIR)\lib\wx1.lib $(WXDIR)\lib\wx2.lib $(WXDIR)\lib\wx3.lib $(WXDIR)\lib\wx4.lib $(WXDIR)\lib\wx5.lib

$(WXDIR)\lib\wx1.lib:      $(COMMONOBJS1) $(PERIPH_LIBS)
	-erase $(WXDIR)\lib\wx1.lib
	lib /PAGESIZE:128 @<<
$(WXDIR)\lib\wx1.lib
y
$(COMMONOBJS1) $(PERIPH_LIBS)
nul
;
<<

$(WXDIR)\lib\wx2.lib:      $(COMMONOBJS2)
	-erase $(WXDIR)\lib\wx2.lib
	lib /PAGESIZE:128 @<<
$(WXDIR)\lib\wx2.lib
y
$(COMMONOBJS2)
nul
;
<<

$(WXDIR)\lib\wx3.lib:      $(GENERICOBJS)
	-erase $(WXDIR)\lib\wx3.lib
	lib /PAGESIZE:128 @<<
$(WXDIR)\lib\wx3.lib
y
$(GENERICOBJS)
nul
;
<<

$(WXDIR)\lib\wx4.lib:      $(MSWOBJS1)
	-erase $(WXDIR)\lib\wx4.lib
	lib /PAGESIZE:128 @<<
$(WXDIR)\lib\wx4.lib
y
$(MSWOBJS1)
nul
;
<<

$(WXDIR)\lib\wx5.lib:      $(MSWOBJS2)
	-erase $(WXDIR)\lib\wx5.lib
	lib /PAGESIZE:128 @<<
$(WXDIR)\lib\wx5.lib
y
$(MSWOBJS2)
nul
;
<<

########################################################
# Windows-specific objects

dummy.obj: dummy.$(SRCSUFF) $(WXDIR)\include\wx\wx.h
        cl @<<
        cl $(CPPFLAGS) /YcWX/WXPREC.H $(DEBUG_FLAGS) /c /Tp $*.$(SRCSUFF)
<<

#dummy.obj: dummy.$(SRCSUFF) $(WXDIR)\include\wx\wx.h
#        cl $(CPPFLAGS) /YcWX/WXPREC.H $(DEBUG_FLAGS) /c /Tp $*.$(SRCSUFF)

dummydll.obj: dummydll.$(SRCSUFF) $(WXDIR)\include\wx\wx.h
        cl @<<
$(CPPFLAGS) /YcWX/WXPREC.H /c /Tp $*.$(SRCSUFF)
<<

#${
    $_ = $project{"WXMSWOBJS1"} . $project{"WXMSWOBJS2"} . $project{"WXCOMMONOBJS1"} . $project{"WXCOMMONOBJS2"} . $project{"WXGENERICOBJS"};
    my @objs = split;
    foreach (@objs) {
        if ( $project{"WXCOBJS"} =~ / \Q$_\E / ) {
            s:\\:/:;
            $text .= $_ . ':     $*.c' . "\n" .
                 '        cl @<<' . "\n" .
                 '$(CPPFLAGS2) /Fo$@ /c /Tc $*.c' . "\n" .
                 "<<\n\n";
        }
        else {
            s:\\:/:;
            $text .= $_ . ':     $*.$(SRCSUFF)' . "\n" .
                 '        cl @<<' . "\n" .
                 '$(CPPFLAGS) /Fo$@ /c /Tp $*.$(SRCSUFF)' . "\n" .
                 "<<\n\n";
        }
    }
#$}

$(OBJECTS):	$(WXDIR)/include/wx/setup.h

# Peripheral components

zlib:
    cd $(WXDIR)\src\zlib
    nmake -f makefile.dos FINAL=$(FINAL)
    cd $(WXDIR)\src\msw

clean_zlib:
    cd $(WXDIR)\src\zlib
    nmake -f makefile.dos clean
    cd $(WXDIR)\src\msw

png:
    cd $(WXDIR)\src\png
    nmake -f makefile.dos FINAL=$(FINAL)
    cd $(WXDIR)\src\msw

clean_png:
    cd $(WXDIR)\src\png
    nmake -f makefile.dos clean
    cd $(WXDIR)\src\msw

clean: $(PERIPH_CLEAN_TARGET)
        -erase *.obj
        -erase ..\lib\*.lib
        -erase *.pdb
        -erase *.sbr
        -erase *.pch
        cd $(WXDIR)\src\generic
        -erase *.pdb
        -erase *.sbr
        -erase *.obj
        cd $(WXDIR)\src\common
        -erase *.pdb
        -erase *.sbr
        -erase *.obj
        cd $(WXDIR)\src\msw\ole
        -erase *.pdb
        -erase *.sbr
        -erase *.obj
        cd $(WXDIR)\src\msw

cleanall: clean


MFTYPE=dos
makefile.$(MFTYPE) : $(WXWIN)\distrib\msw\tmake\filelist.txt $(WXWIN)\distrib\msw\tmake\$(MFTYPE).t
	cd $(WXWIN)\distrib\msw\tmake
	tmake -t $(MFTYPE) wxwin.pro -o makefile.$(MFTYPE)
	copy makefile.$(MFTYPE) $(WXWIN)\src\msw
