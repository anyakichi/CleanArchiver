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

#import "Dmg.h"

@implementation Dmg


#pragma mark -
#pragma mark Creating and Deallocating Objects

- (id)init
{

	if (self = [super init])
		[_task setLaunchPath:[[[NSBundle mainBundle] bundlePath]
		    stringByAppendingString:@"/Contents/Resources/mkdmg"]];
	return self;
}

#pragma mark -
#pragma mark Running and Stopping a Task

- (void)launch
{
	NSMutableArray *args;
	int i;
	
	args = [[NSMutableArray alloc] init];

	if (_mode == DMG_CREATE_IE)
	    [args addObject:@"-i"];

	for (i = 0; i < [_excludedFiles count]; i++) {
		[args addObject:@"-x"];
		[args addObject:[_excludedFiles objectAtIndex:i]];
	}

	[args addObject:@"-o"];
	[args addObject:_output];
	[args addObject:_input];

	[_task setArguments:args];
	[_task launch];

	[args release];
}

+ (Dmg *)launchedTaskWithInput:(id)i withOutput:(id)o withMode:(unsigned)m
{
	Dmg *dmg;
	    
	dmg = [[Dmg alloc] init];

	[dmg setInput:i];
	[dmg setOutput:o];
	[dmg setArchiveMode:m];

	[dmg launch];
	return [dmg autorelease];  // ???: Where is the autoreleasepool?
}

@end
