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

#import "Zip.h"

@implementation Zip

- (void)launch
{
	NSFileManager *fm;
	NSMutableArray *args;
	int i;

	fm = [NSFileManager defaultManager];
	args = [[NSMutableArray alloc] init];

	[args addObject:@"-q"];

	switch (_mode) {
	case ZIP:
		[_task setLaunchPath:@"/usr/bin/zip"];
		[args addObject:@"-r"];

		if ([_output isKindOfClass:[NSString class]]) {
			if (![fm fileExistsAtPath:_output])
				[fm createFileAtPath:_output
				    contents:nil attributes:nil];
			[_task setStandardOutput:
			    [NSFileHandle fileHandleForWritingAtPath:_output]];
		} else if ([_output isKindOfClass:[NSFileHandle class]] ||
			   [_output isKindOfClass:[NSPipe class]])
			[_task setStandardOutput:_output];

		[args addObject:@"-"];

		if ([_input isKindOfClass:[NSFileHandle class]] ||
		    [_input isKindOfClass:[NSPipe class]]) {
			[args addObject:@"-"];
			[_task setStandardInput:_input];
		} else if ([_input isKindOfClass:[NSArray class]])
			[args addObjectsFromArray:_input];
		else if ([_input isKindOfClass:[NSString class]])
			[args addObject:_input];
		break;
	case UNZIP:
		[_task setLaunchPath:@"/usr/bin/unzip"];
		if ([_input isKindOfClass:[NSString class]])
			[args addObject:_input];
		break;
	default:
		exit(1);
	}

	for (i = 0; i < [_excludedFiles count]; i++) {
		[args addObject:@"-x"];
		[args addObject:[@"*" stringByAppendingString:
				    [_excludedFiles objectAtIndex:i]]];
	}

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

+ (Zip *)launchedTaskWithInput:(id)i withOutput:(id)o withMode:(unsigned)m
{
	Zip *zip;
	    
	zip = [[Zip alloc] init];

	[zip setInput:i];
	[zip setOutput:o];
	[zip setArchiveMode:m];

	[zip launch];
	return [zip autorelease];
}

@end
