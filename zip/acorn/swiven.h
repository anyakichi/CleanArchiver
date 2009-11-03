/*
  Copyright (c) 1990-2009 Info-ZIP.  All rights reserved.

  See the accompanying file LICENSE, version 2009-Jan-2 or later
  (the contents of which are also included in zip.h) for terms of use.
  If, for some reason, all these files are missing, the Info-ZIP license
  also may be found at:  ftp://ftp.info-zip.org/pub/infozip/license.html
*/
/* swiven.h */

#ifndef __swiven_h
#define __swiven_h

#include "kernel.h"

_kernel_oserror *SWI_OS_FSControl_26(const char *source, const char *dest,
				     int actionmask);
/* copy */

_kernel_oserror *SWI_OS_FSControl_27(const char *filename, int actionmask);
/* wipe */

_kernel_oserror *SWI_OS_GBPB_9(const char *dirname, void *buf, int *number,
			       int *offset, int size, const char *match);
/* read dir */

_kernel_oserror *SWI_OS_File_1(const char *filename, unsigned int loadaddr,
			       unsigned int execaddr, int attrib);
/* write file attributes */

_kernel_oserror *SWI_OS_File_5(const char *filename, int *objtype,
			       unsigned int *loadaddr,
			       unsigned int *execaddr,
			       int *length, int *attrib);
/* read file info */

_kernel_oserror *SWI_OS_File_6(const char *filename);
/* delete */

_kernel_oserror *SWI_OS_File_7(const char *filename, int loadaddr,
			       int execaddr, int size);
/* create an empty file */

_kernel_oserror *SWI_OS_CLI(const char *cmd);
/* execute a command */

int SWI_OS_ReadC(void);
/* get a key from the keyboard buffer */

_kernel_oserror *SWI_OS_ReadVarVal(const char *var, char *buf, int len,
				   int *bytesused);
/* reads an OS varibale */

_kernel_oserror *SWI_OS_FSControl_37(const char *pathname, char *buffer,
				     int *size);
/* canonicalise path */

_kernel_oserror *SWI_DDEUtils_Prefix(const char *dir);
/* sets the 'prefix' directory */

int SWI_Read_Timezone(void);
/* returns the timezone offset (centiseconds) */

#endif /* !__swiven_h */
