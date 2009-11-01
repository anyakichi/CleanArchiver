//
// CAView.m:
// 	View class of CleanArchiver
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

#import "CAView.h"

@implementation CAView

#pragma mark -
#pragma mark Responding to Being Loaded from a Nib File

- (void)awakeFromNib
{

	_backgroundImage = [self image];
	_activeBackgroundImage = [[NSImage alloc] initWithContentsOfFile:
	    [[[NSBundle mainBundle] bundlePath] stringByAppendingString:
		@"/Contents/Resources/bgactive.png"]]; // ???: Does this have to be released?
}

#pragma mark -
#pragma mark Creating Instances

- (id)initWithFrame:(NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect]) {
		[self registerForDraggedTypes:
		    [NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
		_dragSessionInProgress = NO;
	}
	return self;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)rect
{

	[super drawRect:rect];
	if (_dragSessionInProgress) {
		[[NSColor selectedTextBackgroundColor] set];
		NSFrameRectWithWidth([self bounds], 3.0);
	}
}

#pragma mark -
#pragma mark Managing a Dragging Session Before an Image Is Released

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	unsigned mask, ret;

	mask = [sender draggingSourceOperationMask];
	ret = (NSDragOperationGeneric & mask);

	if (ret != NSDragOperationNone) {
		_dragSessionInProgress = YES;
		[self setImage:_activeBackgroundImage];
		[self setNeedsDisplay:YES];
	}
	return ret;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{

	_dragSessionInProgress = NO;
	[self setImage:_backgroundImage];
	[self setNeedsDisplay:YES];
}


#pragma mark -
#pragma mark Managing a Dragging Session After an Image Is Released

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{

	_dragSessionInProgress = NO;
	[self setImage:_backgroundImage];
	[self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{

	return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSArray *filenames;
	NSNotificationCenter *nc;
	NSPasteboard *pb;

	nc = [NSNotificationCenter defaultCenter];
	pb = [sender draggingPasteboard];
	filenames = [pb propertyListForType:NSFilenamesPboardType];

	[nc postNotificationName:AOFilesDroppedNotification
	    object:filenames];
	return YES;
}

@end

NSString *AOFilesDroppedNotification =
	@"AOFilesDroppedNotification";
