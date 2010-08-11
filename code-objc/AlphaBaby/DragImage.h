//
//  DragImage.h
//  AlphaBaby
//
//  Created by Laura Dickey on Fri Jan 07 2005.
//  Copyright (c) 2005 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface DragImage : NSObject {
	NSImage *myImage;
	float imgWidth;
	float frameWidth;
	float imgHeight;
	int numFrames;
	int currentFrame;
}

// initialization routine which takes a file name and creates an object
// initialization routine which takes a resource name and creates an object

- (id) initWithFileName:(id)fname;

// need to know the total size of the image.
// need to look at the file/resource name, and extract a number from the end of the name, ignoring the suffix
// need to save that number - the "frame" number
// need to save the total size of the object
// call a routine to have it do a composite operation at a supplied location
// the compositing routine is responsible for advancing the current frame.
// need routines to return size of a frame

- (float)imageHeight;
- (float)imageWidth;

- (void) drawImageToLocation:(NSPoint)loc;

@end
