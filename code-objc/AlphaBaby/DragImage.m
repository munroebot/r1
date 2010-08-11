//
//  DragImage.m
//  AlphaBaby
//
//  Created by Laura Dickey on Fri Jan 07 2005.
//  Copyright (c) 2005 __MyCompanyName__. All rights reserved.
//

//01234567890123456789012345678901234567890123456789012345678901234567890123456789

#import "DragImage.h"
#import "ABDebug.h"

/*
 NSImage *myImage;
	float imgWidth;
	float frameWidth;
	float imgHeight;
	int numFrames;
	int currentFrame;
*/ 

@implementation DragImage

- (id) initWithFileName:(id)fname
{
	NSString *baseName;
	NSScanner *scanner;
	int frameNum;
	//BOOL gotInt;
	NSRange numRange;
	
	self = [super init];
	if (self == nil) {
		return self;
	}
	
	myImage = [[NSImage alloc] initWithContentsOfFile:fname];
	if (!myImage) {
		return self;
	}
	frameNum = 0;
	baseName = [[fname lastPathComponent] stringByDeletingPathExtension];
	numRange = [baseName rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSBackwardsSearch];
	if ((numRange.length > 0) && ((numRange.location + numRange.length) == [baseName length])) {
		// we found a string!
		scanner = [NSScanner scannerWithString:baseName];
		[scanner setScanLocation:numRange.location];
		if (![scanner scanInt:&frameNum]) {
			ABLog(@"!Bad");
		}
	}
	// need to look for a number at the end of baseName, and extract it.
	    /*
	scanner = [NSScanner scannerWithString:baseName];
	frameNum = 0;
	while (![scanner isAtEnd]) {
		gotInt = [scanner scanInt:&frameNum];
	}
	     */
	imgWidth = [myImage size].width;
	imgHeight = [myImage size].height;
	if (frameNum > 1) {
		numFrames = frameNum;
	} else {
		numFrames = 1;
	}
	currentFrame = 0;
	frameWidth = (imgWidth / numFrames);
	return self;
}

	// need to know the total size of the image.
	// need to look at the file/resource name, and extract a number from the end of the name, ignoring the suffix
	// need to save that number - the "frame" number
	// need to save the total size of the object
	// call a routine to have it do a composite operation at a supplied location
	// the compositing routine is responsible for advancing the current frame.
	// need routines to return size of a frame

- (float)imageHeight
{
	return imgWidth;
}
- (float)imageWidth
{
	return frameWidth;
}

- (void) drawImageToLocation:(NSPoint)loc
{
	NSRect srcRect = 
		NSMakeRect(currentFrame * frameWidth, 0, frameWidth, imgHeight);
	[myImage compositeToPoint:loc fromRect:srcRect 
			operation:NSCompositeSourceOver];
	++currentFrame;
	if (currentFrame == numFrames) {
		currentFrame = 0;
	}
}
@end
