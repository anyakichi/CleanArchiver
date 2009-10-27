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

#import "Archiver.h"

@implementation Archiver

#pragma mark -
#pragma mark Creating and Deallocating Objects

- (id)init
{
	NSNotificationCenter *nc;

	nc = [NSNotificationCenter defaultCenter];

	if (self = [super init]) {
		[nc addObserver:self
		    selector:@selector(taskDidTerminate:)
		    name:NSTaskDidTerminateNotification 
		    object:_task];
	
		[self setCurrentDirectoryPath:@""];
		[self setInput:nil];
		[self setOutput:nil];
		[self setSavingResourceFork:YES];
		[self setArchiveMode:0];

		_task = [[NSTask alloc] init];
	}
	return self;
}

- (void)dealloc
{
	NSNotificationCenter *nc;

	nc = [NSNotificationCenter defaultCenter];

	[self terminate];
	[nc removeObserver:self];

	[_input release]; // ???: check when _input and _output will be released. 
	[_output release];
	[_task release];
	[super dealloc];
}

#pragma mark -
#pragma mark Running and Stopping a Task
- (void)launch
{

	[_task launch];
}

- (void)resume
{
    
	[_task resume];
}

- (void)suspend
{
    
	[_task suspend];
}

- (void)terminate
{

	[_task terminate];
}

- (void)waitUntilExit
{

	[_task waitUntilExit];
}

#pragma mark -
#pragma mark Querying the Task State

- (int)terminationStatus
{

	return [_task terminationStatus];
}

- (void)taskDidTerminate:(NSNotification *)n
{

	if ([n object] == _task)
		[[NSNotificationCenter defaultCenter]
		    postNotificationName:
			AOArchiverDidFinishArchivingNotification
		    object:self];
}

#pragma mark -
#pragma mark Setter and Getter method

- (NSString *)currentDirectoryPath
{

	return [_task currentDirectoryPath];
}
- (void)setCurrentDirectoryPath:(NSString *)path
{

	[_task setCurrentDirectoryPath:path];
}

- (id)input
{

	return _input;
}
- (void)setInput:(id)anObject
{

	[anObject retain];
	[_input release];
	_input = anObject;
}

- (id)output
{

	return _output;
}
- (void)setOutput:(id)anObject
{

	[anObject retain];
	[_output release];
	_output = anObject;
}

- (NSArray *)excludedFiles
{

	return _excludedFiles;
}
- (void)setExcludedFiles:(NSArray *)filenames
{

	[filenames retain];
	[_excludedFiles release];
	_excludedFiles = filenames;
}

- (BOOL)savingResourceFork
{

	return _rsrc;
}
- (void)setSavingResourceFork:(BOOL)yn
{

	_rsrc = yn;
}

- (unsigned)archiveMode
{

	return _mode;
}
- (void)setArchiveMode:(unsigned)m
{

	_mode = m;
}

@end

NSString *const AOArchiverDidFinishArchivingNotification =
	      @"AOArchiverDidFinishArchivingNotification";
