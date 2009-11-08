//
// Carc.m:
// 	carc front end
//
// Copyright (c) 2009 INAJIMA Daisuke All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
// OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
// SUCH DAMAGE.
//

#import "Carc.h"

@implementation Carc

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

	[self setArchiveType:NULL_TYPE];
	[self setArchivePassword:nil];
	[self setCompressionLevel:-1];
	[self setExcludeMacFiles:NO];
	[self setExcludedFiles:nil];
	[self setSaveResourceFork:YES];

	_task = [[NSTask alloc] init];
	[_task setLaunchPath:[[[NSBundle mainBundle] bundlePath]
	    stringByAppendingString:@"/Contents/Resources/carc"]];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc;

    nc = [NSNotificationCenter defaultCenter];

    [self terminate];
    [nc removeObserver:self];

    [_input release];
    [_output release];
    [_task release];
    [super dealloc];
}

#pragma mark -
#pragma mark Running and Stopping a Task

- (void)launch
{
    NSString *path;
    NSMutableArray *args;
    int i;

    args = [[NSMutableArray alloc] init];

    [args addObject:@"-t"];
    switch (_archiveType) {
    case BZIP2:
	[args addObject:@"bzip2"];
	break;
    case DMG:
	[args addObject:@"dmg"];
	break;
    case GZIP:
	[args addObject:@"gzip"];
	break;
    case RAR:
	[args addObject:@"rar"];
	break;
    case SZIP:
	[args addObject:@"7zip"];
	break;
    case ZIP:
	[args addObject:@"zip"];
	break;
    default:
	goto fail;
    }

    if (_archivePassword != nil) {
	[args addObject:@"-P"];
	[args addObject:_archivePassword];
    }

    if (_compressionLevel != -1)
	[args addObject:[NSString stringWithFormat:@"-%d", _compressionLevel]];

    if (_encoding != nil) {
	[args addObject:@"-E"];
	[args addObject:_encoding];
    }

    if (_excludeMacFiles)
	[args addObject:@"-M"];

    for (i = 0; i < [_excludedFiles count]; i++) {
	[args addObject:@"-x"];
	[args addObject:[_excludedFiles objectAtIndex:i]];
    }

    if (_saveResourceFork)
	[args addObject:@"-R"];

    path = [[[NSBundle mainBundle] bundlePath]
	    stringByAppendingString:@"/Contents/Resources"];
    path = [NSString stringWithFormat:@"%@:/bin:/usr/bin", path];
    path = [NSString stringWithFormat:@"%@:/usr/local/bin:/usr/pkg/bin", path];
    path = [NSString stringWithFormat:@"%@:/opt/local/bin:/sw/bin", path];

    [_task setEnvironment:[NSDictionary dictionaryWithObject:path
		   forKey:@"PATH"]];

    if ([_output isKindOfClass:[NSFileHandle class]] ||
	[_output isKindOfClass:[NSPipe class]]) {
	[args addObject:@"-"];
	[_task setStandardOutput:_output];
    } else if ([_output isKindOfClass:[NSString class]])
	[args addObject:_output];
    else
	goto fail;

    if ([_input isKindOfClass:[NSFileHandle class]] ||
	[_input isKindOfClass:[NSPipe class]]) {
	[args addObject:@"-"];
	[_task setStandardInput:_input];
    } else if ([_input isKindOfClass:[NSArray class]])
	[args addObjectsFromArray:_input];
    else if ([_input isKindOfClass:[NSString class]])
	[args addObject:_input];
    else
	goto fail;

    [_task setArguments:args];
    [_task launch];

fail:
    [args release];
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
	    postNotificationName:AOCarcDidFinishArchivingNotification
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

- (NSString *)archivePassword
{

    return _archivePassword;
}
- (void)setArchivePassword:(NSString *)password
{

    [password retain];
    [_archivePassword release];
    _archivePassword = password;
}

- (enum archiveType)archiveType
{

    return _archiveType;
}
- (void)setArchiveType:(enum archiveType)type
{

    _archiveType = type;
}

- (int)compressionLevel
{

    return _compressionLevel;
}
- (void)setCompressionLevel:(int)level
{

    _compressionLevel = level;
}

- (NSString *)encoding
{

    return _encoding;
}
- (void)setEncoding:(NSString *)encoding
{

    [encoding retain];
    [_encoding release];
    _encoding = encoding;
}

- (BOOL)excludeMacFiles
{

    return _excludeMacFiles;
}
- (void)setExcludeMacFiles:(BOOL)yn
{

    _excludeMacFiles = yn;
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

- (BOOL)internetEnabledDMG
{

    return _internetEnabledDMG;
}
- (void)setInternetEnabledDMG:(BOOL)yn
{

    _internetEnabledDMG = yn;
}

- (BOOL)saveResourceFork
{

    return _saveResourceFork;
}
- (void)setSaveResourceFork:(BOOL)yn
{

    _saveResourceFork = yn;
}

@end

NSString *const AOCarcDidFinishArchivingNotification =
	      @"AOCarcDidFinishArchivingNotification";
