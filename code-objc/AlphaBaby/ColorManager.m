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

#import "ColorManager.h"
#import "krand.h"
#import "ABDebug.h"

NSString *lastColorName;

@implementation MyColorList
-(id)initWithKind:(int)kind
{
	if ([super init]) {
		myKind = kind;
	}
	return self;
}

- (NSColor *)getPastelColor
{
	float hue = (rand_get_max(255) * 1.0) / 255.0;

	return [NSColor colorWithDeviceHue:hue saturation:0.3 brightness:1.0 alpha:1.0];
}

- (NSColor *)getBrightColor
{
	float hue = (rand_get_max(255) * 1.0) / 255.0;

	return [NSColor colorWithDeviceHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

- (NSColor *)getAnyColor
{
	float red;
	float green;
	float blue;

	red = (rand_get_max(255) * 1.0) / 255.0;
	green = (rand_get_max(255) * 1.0) / 255.0;
	blue = (rand_get_max(255) * 1.0) / 255.0;
	
	return [NSColor colorWithDeviceRed:red  green:green blue:blue alpha:1.0];
}

- (NSColor *)randomColor
{
	switch(myKind) {
	case CL_ALL:
		return [self getAnyColor];
		break;
	case CL_BRIGHT:
		return [self getBrightColor];
		break;
	case CL_PASTEL:
		return [self getPastelColor];
		break;
	}
	return nil;
}
@end

@implementation ColorSet

- (id)initWithMyColorList:(MyColorList *)theCL
{
	if ([super init]) {
		mcl = theCL;
		[mcl retain];
		cl = nil;
		allKeys = nil;
	}
	return self;
}

- (id)initWithColorList:(NSColorList *)theCL
{
	if ([super init]) {
		cl = theCL;
		[cl retain];
		allKeys = [cl allKeys];
		[allKeys retain];
		mcl = nil;
	}
	return self;
}

- (id)initWithFixedColor:(NSColor *)theColor
{
	if ([super init]) {
		cl = nil;
		mcl = nil;
		allKeys = nil;
		fixedColor = [theColor copy];
	}
	return self;
}

- (void)updateFixedColor:(NSColor *)nextColor
{
	if (fixedColor != nextColor) {
		[fixedColor release];
		fixedColor = [nextColor copy];
	}
}

- (NSColor *)randomColor
{
	if (cl) {
		int i;
		NSString *colorKey;
		NSColor *color;

		i = rand_get_max([allKeys count] - 1);
		colorKey = (NSString *) [allKeys objectAtIndex:i];
		ABLog(@"Picked color %d named %@", i, colorKey);
		color = [cl colorWithKey:colorKey];
		lastColorName = colorKey;
		[lastColorName retain];
		//ABLog(@"Color is %f %f %", [color redComponent] * 255.0, [color greenComponent] * 255.0, [color blueComponent] * 255.0);
		return color;
		
	} else if (mcl) {
		return [mcl randomColor];
	} else if (fixedColor) {
		return fixedColor;
	}
	return nil;
}

@end

@implementation ColorManager

- (id) init
{
	NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
	NSColorList *infantCL;
	NSColorList *primaryCL;
	NSColorList *rainbowCL;
	
	infantCL = [[[NSColorList alloc] initWithName:@"Infant" fromFile:[myBundle pathForResource:@"Infant" ofType:@"clr"]] autorelease];
	primaryCL = [[[NSColorList alloc] initWithName:@"Primary" fromFile:[myBundle pathForResource:@"Primary" ofType:@"clr"]] autorelease];
	rainbowCL = [[[NSColorList alloc] initWithName:@"Rainbow" fromFile:[myBundle pathForResource:@"Rainbow" ofType:@"clr"]] autorelease];
	
	colorSets = [NSDictionary dictionaryWithObjectsAndKeys:
		[[ColorSet alloc] initWithMyColorList:[(MyColorList *)[MyColorList alloc] initWithKind:CL_ALL]], @"All",
		[[ColorSet alloc] initWithMyColorList:[(MyColorList *)[MyColorList alloc] initWithKind:CL_BRIGHT]], @"Bright",
		[[ColorSet alloc] initWithMyColorList:[(MyColorList *)[MyColorList alloc] initWithKind:CL_PASTEL]], @"Pastel",
		[[ColorSet alloc] initWithColorList:infantCL], @"Infant",
		[[ColorSet alloc] initWithColorList:primaryCL], @"Primary",
		[[ColorSet alloc] initWithColorList:rainbowCL], @"Rainbow",
		[[ColorSet alloc] initWithFixedColor:[NSColor blackColor]], @"Fixed color...",
		nil];
	[colorSets retain];
	lastColorName = nil;
		return self;
}

- (ColorSet *)getCurrentColorSet
{
	return [colorSets objectForKey:currentColorSetName];
}

- (NSString *)getCurrentColorSetName
{
	return currentColorSetName;
}

- (NSColor *)randomColor
{
	if (lastColorName != nil) {
		[lastColorName release];
		lastColorName = nil;
	}
	return [currentColorSet randomColor];
	
}

- (void)setCurrentColorSet:(NSString *)name
{
	currentColorSetName = name;
	currentColorSet = (ColorSet *)[colorSets objectForKey:currentColorSetName];
}

- (NSString *)getLastColorName
{
	return lastColorName;
}

- (void)updateFixedColor:(NSColor *)newColor
{
	ColorSet	*fixedColorset;
	
	fixedColorset = [colorSets objectForKey:@"Fixed color..."];
	[fixedColorset updateFixedColor:newColor];
}

@end
