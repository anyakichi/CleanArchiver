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

#import "Gzip.h"

@implementation Gzip

- (id)init
{

	if (self = [super init])
		[_task setLaunchPath:@"/usr/bin/gzip"];
	return self;
}

- (void)launch
{
	NSFileManager *fm;
	NSMutableArray *args;

	args = [[NSMutableArray alloc] init];

	fm = [NSFileManager defaultManager];

	[args addObject:@"-c"];
	if (_mode == GUNZIP)
		[args addObject:@"-d"];

	if ([_output isKindOfClass:[NSString class]]) {
		if (![fm fileExistsAtPath:_output])
			[fm createFileAtPath:_output
			    contents:nil attributes:nil];
		[_task setStandardOutput:
		    [NSFileHandle fileHandleForWritingAtPath:_output]];
	} else if ([_output isKindOfClass:[NSFileHandle class]] ||
		   [_output isKindOfClass:[NSPipe class]])
		[_task setStandardOutput:_output];

	if ([_input isKindOfClass:[NSFileHandle class]] ||
	    [_input isKindOfClass:[NSPipe class]])
		[_task setStandardInput:_input];
	else if ([_input isKindOfClass:[NSString class]])
		[args addObject:_input];

	[_task setArguments:args];
	[_task launch];

	[args release];
}

- (void)taskDidTerminate:(NSNotification *)n
{
	NSFileHandle *fh;

	if ([_output isKindOfClass:[NSString class]]) {
		fh = [_task standardOutput];
		[fh truncateFileAtOffset:[fh offsetInFile]];
		[fh closeFile];
	}

	[super taskDidTerminate:n];
}

+ (Gzip *)launchedTaskWithInput:(id)i withOutput:(id)o withMode:(unsigned)m
{
	Gzip *gzip;
	
	gzip = [[Gzip alloc] init];

	[gzip setInput:i];
	[gzip setOutput:o];
	[gzip setArchiveMode:m];

	[gzip launch];
	return [gzip autorelease];
}

@end
