//
// Carc.h:
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

#import <Foundation/Foundation.h>

enum archiveType {
    NULL_TYPE = 0,
    BZIP2,
    DMG,
    GZIP,
    RAR,
    SZIP,
    ZIP,
};

@interface Carc : NSObject
{
    NSTask *_task;

    id _input;
    id _output;

    NSString *_archivePassword;
    enum archiveType _archiveType;
    int _compressionLevel;
    NSString *_encoding;
    BOOL _excludeMacFiles;
    NSArray *_excludedFiles;
    BOOL _internetEnabledDMG;
}

- (id)init;
- (void)dealloc;

// Task management methods
- (void)launch;
- (void)resume;
- (void)suspend;
- (void)terminate;
- (void)waitUntilExit;
- (int)terminationStatus;
- (NSString *)currentDirectoryPath;
- (void)setCurrentDirectoryPath:(NSString *)p;

- (void)taskDidTerminate:(NSNotification *)n;

// input is one of NSString *, NSFileHandle *, NSPipe * and NSArray * of
// NSString *.
- (id)input;
- (void)setInput:(id)anObject;

// output is one of NSString *, NSFIleHandle *, and NSPipe *.
- (id)output;
- (void)setOutput:(id)anObject;

// Password for archive
- (NSString *)archivePassword;
- (void)setArchivePassword:(NSString *)password;

// Type of archive
- (enum archiveType)archiveType;
- (void)setArchiveType:(enum archiveType)type;

// Compression level; -1 is archiver's default
- (int)compressionLevel;
- (void)setCompressionLevel:(int)level;

// Encoding of path names in archive
- (NSString *)encoding;
- (void)setEncoding:(NSString *)encoding;

// Exclude mac-specific files such as ._*, .DS_Store, and icon\r.
- (BOOL)excludeMacFiles;
- (void)setExcludeMacFiles:(BOOL)yn;

// Exclude files matched for these patterns
- (NSArray *)excludedFiles;
- (void)setExcludedFiles:(NSArray *)filenames;

// Create internet-enabled DMG
- (BOOL)internetEnabledDMG;
- (void)setInternetEnabledDMG:(BOOL)yn;

@end

extern NSString *const AOCarcDidFinishArchivingNotification;
