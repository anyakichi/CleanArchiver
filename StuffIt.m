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

#import "StuffIt.h"

@implementation StuffIt

- (id)init
{

	if (self = [super init])
		[_task setLaunchPath:[[[NSBundle mainBundle] bundlePath]
		    stringByAppendingString:@"/Contents/Resources/stuffit"]];
	return self;
}

- (void)launch
{
	NSMutableArray *args;

	args = [[NSMutableArray alloc] init];

	switch (_mode) {
	case STUFFIT5:
		[args addObject:@"-f"];
		[args addObject:@"5"];
		break;
	case STUFFITX:
		[args addObject:@"-f"];
		[args addObject:@"X"];
		break;
	case UNSTUFFIT:
		[args addObject:@"-d"];
		break;
	default:
		exit(1);
	}

	if ([_excludedFiles count] != 0)
		[args addObject:@"-c"];

	if ([_input isKindOfClass:[NSArray class]])
		[args addObjectsFromArray:_input];
	else if ([_input isKindOfClass:[NSString class]])
		[args addObject:_input];

	[_task setArguments:args];
	[_task launch];

	[args release];
}

- (StuffIt *)launchedTaskWithInput:(id)i withOutput:(id)o withMode:(unsigned)m
{
	StuffIt *sit;
	
	sit = [[StuffIt alloc] init];

	[sit setInput:i];
	[sit setOutput:o];
	[sit setArchiveMode:m];

	[sit launch];
	return [sit autorelease];
}

@end
