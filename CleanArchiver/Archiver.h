/*	$Id$	*/

/*
 * Copyright (c) 2005 Inajima Daisuke All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the copyright holder may not be used to endorse or
 *    promote products derived from this software without specific prior
 *    written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

@interface Archiver : NSObject
{
	NSTask *_task;
	id _input;
	id _output;
	NSArray *_excludedFiles;
	unsigned _mode;
	BOOL _rsrc;
}

- (id)init;
- (void)dealloc;

/* same as the procedures of NSTask. */
- (void)launch;
- (void)resume;
- (void)suspend;
- (void)terminate;
- (void)waitUntilExit;
- (int)terminationStatus;

- (void)taskDidTerminate:(NSNotification *)n;

- (NSString *)currentDirectoryPath;
- (void)setCurrentDirectoryPath:(NSString *)p;

/*
 * input is probably one of NSString *, NSFileHandle*, NSPipe * and NSArray *.
 */
- (id)input;
- (void)setInput:(id)anObject;

/*
 * output is probably one of NSString *, NSFIleHandle *, and NSPipe *.
 * Details are decided by a class inheriting this class.
 * It is safe that a controller opens a file and gives its file handle to the
 * procedure because this class may not offer enough error trapping.
 */
- (id)output;
- (void)setOutput:(id)anObject;

- (NSArray *)excludedFiles;
- (void)setExcludedFiles:(NSArray *)filenames;

- (BOOL)savingResourceFork;
- (void)setSavingResourceFork:(BOOL)yn;

- (unsigned)archiveMode;
- (void)setArchiveMode:(unsigned)m;

@end

extern NSString *const AOArchiverDidFinishArchivingNotification;
