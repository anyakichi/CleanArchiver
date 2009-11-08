//
// CAController.h:
// 	Controller class of CleanArchiver
//
// Copyright (c) 2005, 2009 INAJIMA Daisuke All rights reserved.
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

#import <Cocoa/Cocoa.h>

// Preference identifiers
extern NSString *AOArchiveIndividually;
extern NSString *AOArchiveType;
extern NSString *AOEncoding;
extern NSString *AOExcludeDot_;
extern NSString *AOExcludeDSS;
extern NSString *AOExcludeIcon;
extern NSString *AOInternetEnabledDMG;
extern NSString *AOReplaceAutomatically;
extern NSString *AOSaveRSRC;

enum archiveTypeMenuIndex {
    DMGT = 0,
    SZIPT,
    BZIP2T,
    GZIPT,
    ZIPT,
};

enum compressionLevelMenuIndex {
    FAST = 0,
    NORMAL,
    BEST,
};

@interface CAController : NSObject
{
    IBOutlet NSButton *_archiveIndividuallyCheck;
    IBOutlet NSButton *_cancelButton;
    IBOutlet NSButton *_excludeDot_Check;
    IBOutlet NSButton *_excludeDSSCheck;
    IBOutlet NSButton *_excludeIconCheck;
    IBOutlet NSButton *_internetEnabledDMGCheck;
    IBOutlet NSButton *_replaceAutomaticallyCheck;
    IBOutlet NSButton *_saveRSRCCheck;
    IBOutlet NSComboBox *_encodingCBox;
    IBOutlet NSPopUpButton *_archiveTypeMenu;
    IBOutlet NSPopUpButton *_compressionLevelMenu;
    IBOutlet NSProgressIndicator *_progressIndicator;
    IBOutlet NSSecureTextField *_passwordField;
    IBOutlet NSTextField *_progressMessage;
    IBOutlet NSWindow *_progressWindow;

    NSMutableArray *_operationQueue;
    id _mainTask;
    int _terminateAfterArchiving;
    BOOL _archiveSessionInProgress;
    BOOL _archivingCancelled;
}

- (void)handleFilesDropped:(NSNotification *)n;
- (void)handleArchiveTerminated:(NSNotification *)n;

- (IBAction)cancelArchiving:(id)sender;
- (IBAction)changeArchiveType:(id)sender;
- (IBAction)saveAsDefault:(id)sender;

- (void)beginProgressPanel;
- (void)beginProgressPanelWithText:(NSString *)s;
- (void)endProgressPanel;

- (NSString *)getFileNameWithCandidate:(NSString *)cname;
- (NSString *)getArchiveFileNameWithSourceFileNames:(NSArray *)sfiles
    withArchiveType:(enum archiveTypeMenuIndex)atype
    withReplaceAutomatically:(BOOL)ra;
- (NSFileHandle *)getFileHandleOfFile:(NSString *)filename;

- (void)prepare:(NSArray *)filenames;
- (void)cleanArchive;

@end
