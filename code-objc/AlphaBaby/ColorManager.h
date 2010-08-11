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

#import <Cocoa/Cocoa.h>

#define CL_ALL 0
#define CL_BRIGHT 1
#define CL_PASTEL 2
#define CL_FIXED 3

@interface MyColorList : NSObject {
	int myKind;
}
- (id)initWithKind:(int)kind;
- (NSColor *)getPastelColor;
- (NSColor *)getBrightColor;
- (NSColor *)getAnyColor;
- (NSColor *)randomColor;

@end

@interface ColorSet : NSObject {
	MyColorList	*mcl;
	NSColorList	*cl;
	NSArray		*allKeys;
	NSColor		*fixedColor;
}
- (id)initWithMyColorList:(MyColorList *)theCL;
- (id)initWithColorList:(NSColorList *)theCL;
- (id)initWithFixedColor:(NSColor *)theColor;
- (void)updateFixedColor:(NSColor *)newColor;
- (NSColor *)randomColor;

@end

@interface ColorManager : NSObject {
	NSDictionary *colorSets;
	NSString *currentColorSetName;
	ColorSet *currentColorSet;
}

- (ColorSet *)getCurrentColorSet;
- (NSString *)getCurrentColorSetName;
- (NSColor *)randomColor;
- (void)setCurrentColorSet:(NSString *)name;
- (NSString *)getLastColorName;

@end
