/*
  Copyright (c) 1990-2009 Info-ZIP.  All rights reserved.

  See the accompanying file LICENSE, version 2009-Jan-2 or later
  (the contents of which are also included in zip.h) for terms of use.
  If, for some reason, all these files are missing, the Info-ZIP license
  also may be found at:  ftp://ftp.info-zip.org/pub/infozip/license.html
*/
/* riscos.h */

#ifndef __riscos_h
#define __riscos_h

#include <limits.h>
#include <time.h>
#include <stdio.h>

#include "swiven.h"

#define MAXFILENAMELEN 1024  /* RISC OS 4 has 1024 limit. 1024 is also the same as FNMAX in zip.h */
#define DIR_BUFSIZE MAXFILENAMELEN   /* Ensure we can read at least one full-length RISC OS 4 filename */

struct stat {
  unsigned int st_dev;
  int st_ino;
  unsigned int st_mode;
  int st_nlink;
  unsigned short st_uid;
  unsigned short st_gid;
  unsigned int st_rdev;
  unsigned int st_size;
  unsigned int st_blksize;
  time_t st_atime;
  time_t st_mtime;
  time_t st_ctime;
};

typedef struct {
  char *dirname;
  void *buf;
  int size;
  char *act;
  int offset;
  int read;
} DIR;

#define dstrm DIR

struct dirent {
  unsigned int d_off;          /* offset of next disk directory entry */
  int d_fileno;                /* file number of entry */
  size_t d_reclen;             /* length of this record */
  size_t d_namlen;             /* length of d_name */
  char d_name[MAXFILENAMELEN]; /* name */
};

#define SPARKID   0x4341        /* = "AC" */
#define SPARKID_2 0x30435241    /* = "ARC0" */

typedef struct {
  short         ID;
  short         size;
  int           ID_2;
  unsigned int  loadaddr;
  unsigned int  execaddr;
  int           attr;
  int           zero;
} extra_block;


#define S_IFMT  0770000

#define S_IFDIR 0040000
#define S_IFREG 0100000  /* 0200000 in UnixLib !?!?!?!? */

#ifndef S_IEXEC
#  define S_IEXEC  0000100
#  define S_IWRITE 0000200
#  define S_IREAD  0000400
#endif

extern char *exts2swap; /* Extensions to swap */

int stat(char *filename,struct stat *res);
DIR *opendir(char *dirname);
struct dirent *readdir(DIR *d);
char *readd(DIR *d);
void closedir(DIR *d);
int unlink(char *f);
int chmod(char *file, int mode);
void setfiletype(char *fname,int ftype);
void getRISCOSexts(char *envstr);
int checkext(char *suff);
int swapext(char *name, char *exptr);
void remove_prefix(void);
void set_prefix(void);
struct tm *riscos_localtime(const time_t *timer);
struct tm *riscos_gmtime(const time_t *timer);

int riscos_fseek(FILE *fd, long offset, int whence);
/* work around broken assumption that fseek() is OK with -ve file offsets */

#endif /* !__riscos_h */
