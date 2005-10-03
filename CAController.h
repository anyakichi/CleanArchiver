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

#import <Cocoa/Cocoa.h>

extern NSString *AOArchiveIndividually;
extern NSString *AOArchiveType;
extern NSString *AOExcludeDSS;
extern NSString *AOExcludeIcon;
extern NSString *AOInternetEnabledDMG;
extern NSString *AOReplaceAutomatically;

enum archive_type {
	GZIPT = 0,
	BZIP2T,
	ZIPT,
	DMGT,
	SITT,
	SITXT
};

@interface CAController : NSObject
{
	IBOutlet NSButton *_archiveIndividuallyCheck;
	IBOutlet NSButton *_cancelButton;
	IBOutlet NSButton *_excludeIconCheck;
	IBOutlet NSButton *_internetEnabledDMGCheck;
	IBOutlet NSButton *_excludeDSSCheck;
	IBOutlet NSButton *_replaceAutomaticallyCheck;
	IBOutlet NSPopUpButton *_archiveTypeMenu;
	IBOutlet NSProgressIndicator *_progressIndicator;
	IBOutlet NSTextField *_progressMessage;
	IBOutlet NSWindow *_progressWindow;

	NSMutableArray *_operationQueue;
	id _mainTask;
	int _terminateAfterArchiving;
	BOOL _archiveSessionInProgress;
	BOOL _archivingCancelled;
}
- (IBAction)saveAsDefault:(id)sender;
- (IBAction)cancelArchiving:(id)sender;

- (void)handleFilesDropped:(NSNotification *)n;
- (void)handleArchiveTerminated:(NSNotification *)n;

- (void)beginProgressPanel;
- (void)beginProgressPanelWithText:(NSString *)s;
- (void)endProgressPanel;

- (NSString *)getFileNameWithCandidate:(NSString *)cname;
- (NSString *)getArchiveFileNameWithSourceFileNames:(NSArray *)sfiles
    withArchiveType:(enum archive_type)atype withReplaceAutomatically:(BOOL)ra;

- (void)prepare:(NSArray *)filenames;
- (void)cleanArchive;

- (NSFileHandle *)getFileHandleOfFile:(NSString *)filename;
@end
