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

#import "Tar.h"

@implementation Tar

#pragma mark -
#pragma mark Creating and Deallocating Objects

- (id)init
{

	if (self = [super init])
		[_task setLaunchPath:@"/usr/bin/tar"];
	return self;
}

#pragma mark -
#pragma mark Running and Stopping a Task

- (void)launch
{
	NSMutableArray *args;
	int i;

	args = [[NSMutableArray alloc] init];

	if (!_rsrc)
		[_task setEnvironment:
		    [NSDictionary
			dictionaryWithObject:@"1"
			forKey:@"COPY_EXTENDED_ATTRIBUTES_DISABLE"]]; //FIXME: 10.5+ use COPYFILE_DISABLE

	for (i = 0; i < [_excludedFiles count]; i++) {
		[args addObject:@"--exclude"];
		[args addObject:[_excludedFiles objectAtIndex:i]];
	}

	switch (_mode) {
	case TAR:
	case TAR_GZIP:
	case TAR_BZIP2:
		[args addObject:@"-cf"];
		if ([_output isKindOfClass:[NSFileHandle class]] ||
		    [_output isKindOfClass:[NSPipe class]]) {
			[args addObject:@"-"];
			[_task setStandardOutput:_output];
		} else if ([_output isKindOfClass:[NSString class]])
			[args addObject:_output];

		if (_mode == TAR_GZIP)
			[args addObject:@"--gzip"];
		else if (_mode == TAR_BZIP2)
			[args addObject:@"--bzip2"];

		if ([_input isKindOfClass:[NSFileHandle class]] ||
		    [_input isKindOfClass:[NSPipe class]])
			[_task setStandardInput:_input];
		else if ([_input isKindOfClass:[NSArray class]])
			[args addObjectsFromArray:_input];
		else if ([_input isKindOfClass:[NSString class]])
			[args addObject:_input];
		break;
	case UNTAR:
	case UNTAR_GZIP:
	case UNTAR_BZIP2:
		[args addObject:@"-xf"];
		if ([_input isKindOfClass:[NSFileHandle class]] ||
		    [_input isKindOfClass:[NSPipe class]]) {
			[args addObject:@"-"];
			[_task setStandardInput:_input];
		} else if ([_input isKindOfClass:[NSString class]])
			[args addObject:_input];

		if (_mode == UNTAR_GZIP)
			[args addObject:@"--gzip"];
		else if (_mode == UNTAR_BZIP2)
			[args addObject:@"--bzip2"];
		break;
	default:
		exit(1);
	}

	[_task setArguments:args];
	[_task launch];

	[args release];
}
@end
