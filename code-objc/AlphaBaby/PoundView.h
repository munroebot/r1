/*
	Copyright 2003-2008 Laura Dickey

	This file is part of AlphaBaby.

	AlphaBaby is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Foobar is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Foobar; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, 
	Boston, MA  02111-1307  USA

	You may contact the author at: alphababy.mac@gmail.com
*/

#import <AppKit/AppKit.h>
#import <Controller.h>
#import <ScreenSaver/ScreenSaver.h>
#import "DragImage.h"

@class Controller;

#ifdef ALPHABABY_SCREENSAVER
@interface PoundView : ScreenSaverView {
#else
@interface PoundView : NSView {
#endif
	NSImage *buffer;
	NSRect myFrame;
	NSWindow *myWindow;
	NSTextView *typingView;
	BOOL usingTypingView;
	NSPoint typingLocation;
	NSGlyph lastChar;
	NSColor *randomColor;
	
	Controller *myController;
	int keyPressed;

	DragImage *starImage;
	NSImage *pinkDot;
	DragImage *duckImage;
	DragImage *truckImage;
	//DragImage *truckDragImage;

	NSPoint mouseDown;
	BOOL hasDragged;
	float currentHue;
	NSBezierPath *dragPath;
	float diam;
	float delta;
	BOOL firstDrag;

	BOOL useBuffer;
	NSTimer *startupPauseTimer;
	BOOL allowAnimation;
	BOOL eventFromUser;
}

- (id) initWithFrame:(NSRect)frameRect andController:(Controller *)c;
- (void)finishInitialization;
- (NSFont *)getDesiredFontSize:(float)desired fromFont:(NSFont *)font;
- (NSFont *) defaultFontForView;
- (NSFont *)currentFontBig:(NSFont *)currentFont;
- (void)playSound;
- (void)playSoundForLetter:(char)theLetter;
- (void)playSoundForShape:(NSString *)shapeName;
- (void)playSoundForImage:(NSImage *)img;
- (void)playSomeNotes;
- (void)setController:(Controller *)c;
- (void)handleKeyDown:(NSEvent *)theEvent fromUser:(BOOL)fromUser;
- (void)handleMouseUp:(NSEvent *)theEvent fromUser:(BOOL)fromUser;
- (void)showAlphaNumKey:(int)key;
- (void)drawShapeOrImageAtPoint:(NSPoint)loc andCenter:(BOOL)center;
- (void)drawShapeAtPoint:(NSPoint)loc andCenter:(BOOL)center;
- (void)drawPolygonToPath:(NSBezierPath *)path withSides:(int)numSides asStar:(BOOL)asStar;
- (void)drawImageAtPoint:(NSPoint)loc andCenter:(BOOL)center;
- (void)checkRefresh;
- (void)showQuitInfo;
- (void)doRedraw;
- (void)myLockFocus;
- (void)myUnlockFocus;
- (void)clearScreen;
- (void)switchToMode:(int)mode;
- (void)resetTypingLocation;
- (NSPoint)getTypingLocation:(NSGlyph)letter isReturn:(BOOL)isReturn;
- (void)updateTypingLocation:(NSGlyph)letter;

#ifdef ALPHABABY_SCREENSAVER
- (void)showScreenSaverQuitInfo;
- (void)restartPauseTimer;
- (void)allowAnimation:(NSTimer *)timer;
#endif

@end
