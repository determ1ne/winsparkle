#!################################################################################
#! File:    micro.t
#! Purpose: tmake template file from which src/micro/files.lst containing the
#!          list of files for wxMicroWindows library is generated by tmake
#! Author:  Robert Roebling
#! Created: 28.01.00
#! Version: $Id: micro.t 13975 2002-02-02 23:15:23Z VS $
#!################################################################################
#${
    #! include the code which parses filelist.txt file and initializes
    #! %wxCommon, %wxGeneric, %wxHtml, %wxUNIX, %wxGTK, %wxMOTIF and
    #! %wxOS2PM hashes.
    IncludeTemplate("filelist.t");

    #! find all our sources
    $project{"COMMONOBJS"} .= "parser.o ";

    foreach $file (sort keys %wxGeneric) {
        next if $wxGeneric{$file} =~ /\bNotMicro\b/;

        ($fileobj = $file) =~ s/cp?p?$/\o/;

        $project{"MICRO_SOURCES"} .= "generic/" . $file . " ";
        $project{"GENERICOBJS"} .= $fileobj . " ";
    }

    foreach $file (sort keys %wxCommon) {
        next if $wxCommon{$file} =~ /\bNotMicro\b/;

        ($fileobj = $file) =~ s/cp?p?$/\o/;

        $project{"MICRO_SOURCES"} .= "common/" . $file . " ";
        $project{"COMMONOBJS"} .= $fileobj . " ";
    }

    foreach $file (sort keys %wxMICRO) {
        ($fileobj = $file) =~ s/cp?p?$/\o/;

        $project{"MICRO_SOURCES"} .= "msw/" . $file . " ";
#!        $project{"GUIOBJS"} .= $fileobj . " ";

        if ( $wxMICRO{$file} =~ /\bL\b/ ) {
            $project{"GUI_LOWLEVEL_OBJS"} .= $fileobj . " ";
        }
    }

    foreach $file (sort keys %wxUNIX) {
        next if $wxUNIX{$file} =~ /\bNotMicro\b/;

        ($fileobj = $file) =~ s/cp?p?$/\o/;

        $project{"MICRO_SOURCES"} .= "unix/" . $file . " ";
        $project{"UNIXOBJS"} .= $fileobj . " ";
    }

    foreach $file (sort keys %wxHTML) {
        ($fileobj = $file) =~ s/cp?p?$/\o/;

        $project{"MICRO_SOURCES"} .= "html/" . $file . " ";
        $project{"HTMLOBJS"} .= $fileobj . " ";
    }

    #! find all our headers
    foreach $file (sort keys %wxWXINCLUDE) {
        $project{"MICRO_HEADERS"} .= $file . " "
    }

    foreach $file (sort keys %wxMSWINCLUDE) {
        $project{"MICRO_HEADERS"} .= "msw/" . $file . " "
    }

    foreach $file (sort keys %wxGENERICINCLUDE) {
        $project{"MICRO_HEADERS"} .= "generic/" . $file . " "
    }

    foreach $file (sort keys %wxUNIXINCLUDE) {
        $project{"MICRO_HEADERS"} .= "unix/" . $file . " "
    }

    foreach $file (sort keys %wxHTMLINCLUDE) {
        $project{"MICRO_HEADERS"} .= "html/" . $file . " "
    }

    foreach $file (sort keys %wxPROTOCOLINCLUDE) {
        $project{"MICRO_HEADERS"} .= "protocol/" . $file . " "
    }
#$}
# This file was automatically generated by tmake 
# DO NOT CHANGE THIS FILE, YOUR CHANGES WILL BE LOST! CHANGE MICRO.T!
ALL_SOURCES = \
		#$ ExpandList("MICRO_SOURCES");

ALL_HEADERS = \
		#$ ExpandList("MICRO_HEADERS");

COMMONOBJS = \
		#$ ExpandList("COMMONOBJS");

GENERICOBJS = \
		#$ ExpandList("GENERICOBJS");

#!GUIOBJS = \
#!		#$ ExpandList("GUIOBJS");
#!
GUI_LOWLEVEL_OBJS = \
		#$ ExpandList("GUI_LOWLEVEL_OBJS");

UNIXOBJS = \
		#$ ExpandList("UNIXOBJS");

HTMLOBJS = \
		#$ ExpandList("HTMLOBJS");

