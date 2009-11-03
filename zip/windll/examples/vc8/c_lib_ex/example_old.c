/*
  Copyright (c) 1990-1999 Info-ZIP.  All rights reserved.

  See the accompanying file LICENSE, version 1999-Oct-05 or later
  (the contents of which are also included in zip.h) for terms of use.
  If, for some reason, both of these files are missing, the Info-ZIP license
  also may be found at:  ftp://ftp.cdrom.com/pub/infozip/license.html
*/
/*
 A very simplistic example of how to load the zip dll and make a call into it.
 Note that none of the command line options are implemented in this example.

 */

#ifndef WIN32
#  define WIN32
#endif
#define API

#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <string.h>
#ifdef __BORLANDC__
#include <dir.h>
#else
#include <direct.h>
#endif
#include "example.h"
//@@@#include "zipver.h"

#ifdef WIN32
#include <commctrl.h>
#include <winver.h>
#else
#include <ver.h>
#endif


static ZpVer				ZipVer;
static ZPOPT				ZipOption;
static ZCL					ZipParams;
static int					ZipResult;
static ZIPUSERFUNCTIONS	ZipUsrFunc;

static char		szFullPath [PATH_MAX + 1];
static char*   sziFiles[] = { "ImgSett.bmp",
										"example.obj"
									 };

/****************************************************************************

    FUNCTION: Main(int argc, char **argv)

****************************************************************************/
#ifdef __BORLANDC__
#  ifdef WIN32
#pragma argsused
#  endif
#endif

int WINAPI DummyPrint(LPSTR szPar, unsigned long ulPar)
{
	szPar;
	printf("%s", szPar);
	return (unsigned int) ulPar;
}

int WINAPI DummyComment(char far *szBuf)
{
	szBuf[0] = '\0';
	return TRUE;
}

int WINAPI DummyPassword(LPSTR p, int n, LPCSTR m, LPCSTR name)
{
	return 1;
}

/* ---------------------------------------------------------------------- */

int main(int argc, char **argv)
{
	char* pPath = strrchr(argv[0], '\\');

	if (argc != 2) {
		return 0;           /* Exits if not proper number of arguments */
	}

	printf("\n%s %s\n", argv[0], argv[1]);

	if (pPath) {
		*szFullPath = '\0';
		strncat(szFullPath, argv[0], (size_t)(pPath - argv[0]));
	} else {
		_getcwd(szFullPath, PATH_MAX);
	}

	ZpVersion(&ZipVer);

	ZipOption.Date					= NULL;
	ZipOption.szRootDir			= szFullPath;					// "C:\\Samples\\TestZip\\Debug\\";
	ZipOption.szTempDir			= szFullPath;
	ZipOption.fTemp				= TRUE;
/*	ZipOption.fSuffix				= FALSE; */
	ZipOption.fEncrypt			= FALSE;
	ZipOption.fSystem				= FALSE;
	ZipOption.fVolume				= FALSE;
	ZipOption.fExtra				= FALSE;
	ZipOption.fNoDirEntries		= FALSE;
	ZipOption.fExcludeDate		= FALSE;
	ZipOption.fIncludeDate		= FALSE;
	ZipOption.fVerbose			= FALSE;
	ZipOption.fQuiet				= FALSE;
	ZipOption.fCRLF_LF			= FALSE;
	ZipOption.fLF_CRLF			= FALSE;
	ZipOption.fJunkDir			= TRUE;
	ZipOption.fGrow				= FALSE;
	ZipOption.fForce				= FALSE;
	ZipOption.fMove				= FALSE;
	ZipOption.fDeleteEntries	= FALSE;
	ZipOption.fUpdate				= FALSE;
	ZipOption.fFreshen			= FALSE;
	ZipOption.fJunkSFX			= FALSE;
	ZipOption.fLatestTime		= FALSE;
	ZipOption.fComment			= FALSE;
	ZipOption.fOffsets			= FALSE;
	ZipOption.fPrivilege			= FALSE;
/*	ZipOption.fEncryption		= FALSE;  read only;	*/
	ZipOption.szSplitSize		= NULL;
	ZipOption.szExcludeList 	= NULL;
	ZipOption.IncludeListCount	= 0;
	ZipOption.IncludeList		= NULL;
	ZipOption.szExcludeList		= NULL;
	ZipOption.ExcludeListCount	= 0;
	ZipOption.ExcludeList		= NULL;
	ZipOption.fRecurse			= 0;
	ZipOption.fRepair				= 0;
	ZipOption.fLevel				= '6';

	ZipParams.argc					= sizeof sziFiles/sizeof sziFiles[0];
	ZipParams.lpszZipFN			= argv[1];
	ZipParams.FNV					= sziFiles;
	ZipParams.lpszAltFNL			= NULL;

	ZipUsrFunc.print									= DummyPrint;
	ZipUsrFunc.comment								= DummyComment;
	ZipUsrFunc.password								= DummyPassword;
	ZipUsrFunc.split									= NULL;
	ZipUsrFunc.ServiceApplication64				= NULL;
	ZipUsrFunc.ServiceApplication64_No_Int64	= NULL;

	ZipResult = ZpInit(&ZipUsrFunc);

	ZipResult = ZpArchive(ZipParams, &ZipOption);

	return 1;
}

