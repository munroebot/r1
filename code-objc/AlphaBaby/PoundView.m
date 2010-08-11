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

#import "PoundView.h"
#import "krand.h"
#import "ABDebug.h"
#import <stdlib.h>

#define ALPHABET @"0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
#define STAR_R 0.38196601125010515181

typedef enum ShapeKind {
	SHAPE_CIRCLE = 0,
	SHAPE_RECTANGLE,
	SHAPE_SQUARE,
	SHAPE_HEART,
	SHAPE_DIAMOND,
	SHAPE_OVAL,
	SHAPE_TRIANGLE,
	SHAPE_PENTAGON,
	SHAPE_HEXAGON,
	SHAPE_OCTAGON,
	SHAPE_STAR,
	SHAPE_MOON,
	SHAPE_TRAPEZOID,
	SHAPE_MAX
} ShapeKind;

float widths[] = {
	0.01,
	0.05,
	0.1,
	0.2,
	0.3
};

/*
060  0   061  1   062  2   063  3   064  4   065  5   066  6   067  7
070  8   071  9   072  :   073  ;   074  <   075  =   076  >   077  ?
100  @   101  A   102  B   103  C   104  D   105  E   106  F   107  G
110  H   111  I   112  J   113  K   114  L   115  M   116  N   117  O
120  P   121  Q   122  R   123  S   124  T   125  U   126  V   127  W
130  X   131  Y   132  Z   133  [   134  \   135  ]   136  ^   137  _
140  `   141  a   142  b   143  c   144  d   145  e   146  f   147  g
150  h   151  i   152  j   153  k   154  l   155  m   156  n   157  o
160  p   161  q   162  r   163  s   164  t   165  u   166  v   167  w
170  x   171  y   172  z   173  {   174  |   175  }   176  ~   177 del
*/

BOOL check_flags(unsigned int eventFlags, unsigned int *myFlags, unsigned int mask);

BOOL
check_flags(unsigned int eventFlags, unsigned int *myFlags, unsigned int mask)
{
	if ((eventFlags & mask) != 0) {
		if ((*myFlags & mask) == 0) {
			*myFlags |= mask;
			return YES;
		}
		ABLog(@"myFlags and eventFlags are both set");
	} else if ((*myFlags & mask) != 0) {
		ABLog(@"clearing %x from myFlags", mask);
		*myFlags &= ~mask;
	}
	return NO;
}


@implementation PoundView

// Initialization routine for the main view of the program
// Called from Controller's applicationDidFinishLaunching routine, after the window has
// been created, and after the user preferences have been initialized, but before
// any user sounds or images are loaded.

#pragma mark INITIALIZATION

- (id)initWithFrame:(NSRect)frame andController:(Controller *)c
{
	ABLog(@"-initwithFrame");
	self = [super initWithFrame:frame];
	if (self == nil) {
		// Bail if initialization fails
		return self;
	}

	myController = c;
	useBuffer = NO;

	myFrame = frame;

	if (useBuffer) {
		buffer = [[NSImage alloc] initWithSize:myFrame.size];		
	}

	[self finishInitialization];
	
	return self;
}

#ifdef ALPHABABY_SCREENSAVER
/*
 * First method called in PoundView when it is loaded as a ScreenSaverView
 * At this point, the view does not have an associated window object yet.
 * We must create the controller object, where much of the initialization
 * takes place.
 */
- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
	self = [super initWithFrame:frame isPreview:isPreview];
	if (self == nil) {
		return self;
	}
	[self setController:[Controller createController:self]];
	[self setAnimationTimeInterval:[myController displayCount]];
	useBuffer = NO; // ????
	myFrame = frame;
	if (useBuffer) {
		buffer = [[NSImage alloc] initWithSize:myFrame.size];
	}
	startupPauseTimer = nil;

	[self finishInitialization];
	
	return self;
}
#endif

/* 
 * Common initialization, whether you are an application or screen saver
 */
- (void)finishInitialization
{
	NSBundle	*myBundle = [NSBundle bundleForClass:[self class]];
	NSString	*imgPath;
	
	// Load our tiff files
	imgPath = [myBundle pathForResource:@"Star" ofType:@"png"];
	if (imgPath) {
		//starImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
		starImage = [[DragImage alloc] initWithFileName:imgPath];
		ABLog(@"Loaded star from %@", imgPath);
	}
	imgPath = [myBundle pathForResource:@"PinkDot" ofType:@"png"];
	if (imgPath) {
		pinkDot = [[NSImage alloc] initWithContentsOfFile:imgPath];
	}
	imgPath = [myBundle pathForResource:@"ducky" ofType:@"png"];
	if (imgPath) {
		//duckImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
		duckImage = [[DragImage alloc] initWithFileName:imgPath];
	}
	imgPath = [myBundle pathForResource:@"trucks4" ofType:@"png"];
	if (imgPath) {
		//truckImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
		truckImage = [[DragImage alloc] initWithFileName:imgPath];
	}
	[NSBezierPath setDefaultLineWidth:(myFrame.size.height * 
					widths[[myController drawingWidth]])];
	[NSBezierPath setDefaultLineJoinStyle:NSRoundLineJoinStyle];
	[NSBezierPath setDefaultLineCapStyle:NSRoundLineCapStyle];
	currentHue = 0.0;
	dragPath = [NSBezierPath bezierPath];
	[dragPath retain];
	randomColor = nil;
}

#pragma mark VIEW SUPPORT

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)isOpaque
{
	return YES;
}

#pragma mark MOUSE EVENTS

- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint mouseLoc;
	unsigned int eventFlags;
	
	ABLog(@"-mouseDown:");
#ifdef ALPHABABY_SCREENSAVER
	[self restartPauseTimer];
#endif
	eventFlags = [theEvent modifierFlags];
	if ((eventFlags & NSShiftKeyMask) == NSShiftKeyMask) {
		ABLog(@"Shift click!");
	}
	mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:[[self window] contentView]];
	ABLog(@"mouseLoc = %f %f\n", mouseLoc.x, mouseLoc.y);
	mouseDown.x = mouseLoc.x;
	mouseDown.y = mouseLoc.y;
	hasDragged = NO;
	firstDrag = YES;
	//diam = (myFrame.size.height * 0.1);
	diam = myFrame.size.height * widths[[myController drawingWidth]];
	[NSBezierPath setDefaultLineWidth:
		(myFrame.size.height * widths[[myController drawingWidth]])];

	delta = (diam / 15.0) * -1.0;
	if ([myController drawingColorKind] == DRAWCOLOR_RANDOM) {
		if (randomColor) {
			[randomColor release];
		}
		randomColor = [[myController colorManager] randomColor];
		[randomColor retain];	
	}
}

- (void) mouseUp:(NSEvent *)theEvent
{
	[self handleMouseUp:theEvent fromUser:YES];
}

- (void)handleMouseUp:(NSEvent *)theEvent fromUser:(BOOL)fromUser
{
	NSPoint mouseLoc;
	
	ABLog(@"-mouseUp:");
#ifdef ALPHABABY_SCREENSAVER
	if (fromUser) {
		[self restartPauseTimer];	
	}
#endif
	eventFromUser = fromUser;
	
	[self checkRefresh];
	
	mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:[[self window] contentView]];
	ABLog(@"mouseLoc = %f %f\n", mouseLoc.x, mouseLoc.y);
	
	if (hasDragged) {
		hasDragged = NO;
		return;
	}
	if ([myController mode] == MODE_ALPHABET) {
		[self handleKeyDown:theEvent fromUser:YES];
		return;
	}
	
	if (([myController mode] != MODE_TYPING) && ([myController mode] != MODE_LETTERS)) {
		[self drawShapeOrImageAtPoint:mouseLoc andCenter:YES];
	}
	
        [myController itemDrawn];
	[self doRedraw];	
}

- (void)mouseDragged:(NSEvent*)theEvent
{
	NSPoint mouseLoc;
	NSPoint prevMouseLoc;
	BOOL drawImage = NO;
	DragImage *image = nil;
	float deltaX, deltaY;
	
	mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:[[self window] contentView]];
	prevMouseLoc = mouseLoc;
	ABLog(@"-mouseDragged: %f %f", mouseLoc.x, mouseLoc.y);
	deltaX = fabs(mouseLoc.x - mouseDown.x);
	deltaY = fabs(mouseLoc.y - mouseDown.y);
	if (firstDrag && [myController useMouse] && ((deltaX < 10) && (deltaY < 10))) {
		return;
	}
	
	if ([myController drawingKind] == DRAW_STARS) {
		drawImage = YES;
		image = starImage;
	} else if ([myController drawingKind] == DRAW_TRUCKS) {
		drawImage = YES;
		image = truckImage;
	} else if ([myController drawingKind] == DRAW_DUCKS) {
		drawImage = YES;
		image = duckImage;
	}
	if (drawImage) {
		if ((deltaX < ([image imageWidth] / 2.0)) && (deltaY < ([image imageHeight] / 2.0))) {
			return;
		}
	}
	[self myLockFocus];
	if (drawImage) {
		mouseLoc.x -= ([image imageWidth] / 2);
		mouseLoc.y -= ([image imageHeight] / 2);
		
		//[image compositeToPoint:mouseLoc operation:NSCompositeSourceOver];
		[image drawImageToLocation:mouseLoc];
	} else {
		// First set the color
		if ([myController drawingColorKind] == DRAWCOLOR_FIXED) {
			[[myController drawingColor] set];
		} else if ([myController drawingColorKind] == DRAWCOLOR_RANDOM) {
			[randomColor set];
		} else if ([myController drawingColorKind] == DRAWCOLOR_RAINBOW) {
			[[NSColor colorWithDeviceHue:(currentHue / 360.0) saturation:1.0 brightness:1.0 alpha:1.0] set];
			currentHue += 1.0;
			if (currentHue >= 360.0) {
				currentHue = 0.0;
			}
		} else {
			[[NSColor redColor] set];
		}
		// Then draw the shape
		if ([myController drawingKind] == DRAW_LINES) {
			[NSBezierPath strokeLineFromPoint:mouseDown toPoint:mouseLoc];	
		} else if ([myController drawingKind] == DRAW_SQUARES) {
			[dragPath removeAllPoints];
			[dragPath appendBezierPathWithRect:NSMakeRect(mouseLoc.x - (diam/2.0), mouseLoc.y - (diam/2.0), diam, diam)];
			[dragPath fill];
			diam += delta;
			if (diam < (myFrame.size.height * widths[[myController drawingWidth]])) {
				delta = -delta;
			} else if (diam > (myFrame.size.height * widths[[myController drawingWidth]])) {
				delta = -delta;
			}			
		} else if ([myController drawingKind] == DRAW_CIRCLES) {
			[dragPath removeAllPoints];
			ABLog(@"diam = %f", diam);
			[dragPath appendBezierPathWithOvalInRect:NSMakeRect(mouseLoc.x - (diam/2.0), mouseLoc.y - (diam/2.0), diam, diam)];
			[dragPath fill];
			diam += delta;
			if (diam < (myFrame.size.height * widths[[myController drawingWidth]] * 0.1)) {
				delta = -delta;
			} else if (diam > (myFrame.size.height * widths[[myController drawingWidth]])) {
				delta = -delta;
			}			
		} else {
			NSAssert(0, @"Invalid drawingKind");
		}
	}
	
	firstDrag = NO;
	mouseDown.x= prevMouseLoc.x;
	mouseDown.y = prevMouseLoc.y;
	hasDragged = YES;
	
	[self doRedraw];
	[self myUnlockFocus];
	// ambulance, fire truck, tow truck, boat, tank, space shuttle, stealth fighter, helicopter, rescue helicopter
	
}

- (void)mouseMoved:(NSEvent *)theEvent
{
	//NSPoint mouseLoc;
	//mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:[[self window] contentView]]; 
	//ABLog(@"-mouseMoved: %f %f %@", mouseLoc.x, mouseLoc.y, [[theEvent window] description]);
	//firstDrag = NO;
	if (![myController useMouse]) {
		[self mouseDragged:theEvent];	
	}
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
	ABLog(@"-rightMouseDown:");
	[self mouseDown:theEvent];
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
	ABLog(@"-rightMouseUp:");
	[self mouseUp:theEvent];
}
- (void)otherMouseDown:(NSEvent *)theEvent
{
	ABLog(@"-otherMouseDown:");
	[self mouseDown:theEvent];
}

- (void)otherMouseUp:(NSEvent *)theEvent
{
	ABLog(@"-otherMouseUp:");
	[self mouseUp:theEvent];
}

- (void)mouseEntered:(NSEvent *)event
{
	ABLog(@"-mouseEntered:");
}

- (void)mouseExited:(NSEvent *)event
{
	ABLog(@"-mouseExited:");
}

- (void)scrollWheel:(NSEvent *)theEvent
{
	ABLog(@"-scrollWheel:");
}

#pragma mark KEY EVENTS

- (void)keyDown:(NSEvent *)theEvent
{
#ifdef ALPHABABY_SCREENSAVER
	[self restartPauseTimer];
#endif	
        [[myController getRandomView] handleKeyDown:theEvent fromUser:YES];
	if ([myController checkQuitCharacter:[[theEvent characters] characterAtIndex:0]]) {
		[super keyDown:theEvent];
	}
        
}

- (void)flagsChanged:(NSEvent *)theEvent
{
	unsigned int myFlags;
	unsigned int eventFlags;
	unsigned int mask = NSAlphaShiftKeyMask;
	BOOL do_event;
	
#ifdef ALPHABABY_SCREENSAVER
	[self restartPauseTimer];
#endif	
	ABLog(@"In flagsChanged, keycode = %d", [theEvent keyCode]);
	eventFlags = [theEvent modifierFlags];
	myFlags = [myController myModifierFlags];
	ABLog(@"eventFlags = %x, myFlags = %x", eventFlags, myFlags);
	do_event = NO;
	while (mask <= NSFunctionKeyMask) {
		ABLog(@"Checking mask %x", mask);
		if (check_flags(eventFlags, &myFlags, mask)) {
			ABLog(@"got a key down event!");
			do_event = YES;
		} else {
			ABLog(@"key was already down or not down at all");
		}
		mask <<= 1;
	}
	[myController setMyModifierFlags:myFlags];
	// Keep track of the flags all the time, 
	// but only do events if we are not in typing mode.
	if ([myController mode] == MODE_TYPING) {
		do_event = NO;
	}
	if (do_event) {
		[[myController getRandomView] 
			handleKeyDown:theEvent fromUser:YES];
	}
}

#pragma mark DRAWING CODE

- (void)drawRect:(NSRect)rect {
	// Drawing code here.
	
	NSRect bounds = [self bounds];
	
	ABLog(@"-drawRect");
	[[myController backgroundColor] set];
	NSRectFill(rect);
	
	if (useBuffer) {
		[buffer drawInRect:bounds fromRect:bounds 
				operation:NSCompositeSourceOver fraction:1.0];
	}
#ifndef ALPHABABY_SCREENSAVER
	[self showQuitInfo];
#endif
	ABLog(@"-drawRect returning");
}

- (void)myLockFocus
{
	if (useBuffer) {
		[buffer lockFocus];
	} else {
		[self lockFocus];
	}
}

- (void)myUnlockFocus
{
	if (useBuffer) {
		[buffer unlockFocus];
	} else {
		[self unlockFocus];
	}
}

- (void)doRedraw
{
	if (useBuffer) {
		[self setNeedsDisplay:YES];
	} else {
		[self lockFocus];
		[[NSGraphicsContext currentContext] flushGraphics];
		[self unlockFocus];
	}
}

- (void)checkRefresh
{
	if ([myController needsRefresh]) {
		[myController clearScreen:self];
	}	
}

- (void)clearScreen
{
	if (useBuffer) {
		[buffer release];
		buffer = [[NSImage alloc] initWithSize:myFrame.size];
	}
	
	[self lockFocus];
	[[myController backgroundColor] set];
	NSRectFill([self bounds]);
	[self unlockFocus];
	[self doRedraw];
	if ([myController mode] == MODE_TYPING) {
		[self resetTypingLocation];
	}
#ifdef ALPHABABY_SCREENSAVER
	[self showScreenSaverQuitInfo];
#endif
	ABLog(@"Clearing screen");	
}

- (void)handleKeyDown:(NSEvent *)theEvent fromUser:(BOOL)fromUser
{
	int keyDown = 0;
	NSPoint loc;
	
	ABLog(@"-handleKeyDown");
	if ([theEvent type] == NSKeyDown) {
		keyDown = [[theEvent characters] characterAtIndex:0];
		ABLog(@"char = %c (%d), keycode = %d", 
				(char)keyDown, keyDown, [theEvent keyCode]);
		// Ignore key repeats
		if ([theEvent isARepeat]) {
			return;
		}
		if (([theEvent keyCode] == 18) && (keyDown != '1')) {
			keyDown = '1';
		}
	}

	eventFromUser = fromUser;
	[self checkRefresh];

	loc.x = 0;
	loc.y = 0;
	keyPressed = keyDown;

	if ([myController mode] == MODE_ALPHABET) {
		// Need to just show the next letter, no matter what key was 
		// pressed.  Just call showAlphaNumKey with an invented key, 
		// kept by the controller
		keyDown = keyPressed = [myController currentAlphabetChar];
		[self showAlphaNumKey:keyDown];
		[self playSoundForLetter:(char)keyDown];
	} else if (isalnum(keyDown) && !([myController onlyImages]) && 
					([myController mode] != MODE_SHAPES)) {
		[self showAlphaNumKey:keyDown];
		[self playSoundForLetter:(char)keyDown];
	} else if ((isprint(keyDown) && [myController usePunctuation]) && 
					!([myController onlyImages]) && 
					([myController mode] != MODE_SHAPES)) {
		[self showAlphaNumKey:keyDown];
		[self playSoundForLetter:(char)keyDown];
	} else if (([myController mode] == MODE_TYPING) &&
		   (isprint(keyDown) || (keyDown == 0x0a) || 
							(keyDown == 0x0d))) {
		[self showAlphaNumKey:keyDown];
	} else if (([myController mode] != MODE_TYPING) && 
					([myController mode] != MODE_LETTERS)) {
		[self drawShapeOrImageAtPoint:loc andCenter:NO];
	}
        [myController itemDrawn];
	[self doRedraw];
}

/* Actually draws a character to the screen.  It takes care of positioning the
 * letter properly, either randomly, in the center, or in lines in typing mode.
 */


- (void)showAlphaNumKey:(int)key
{
	NSBezierPath	*path = [NSBezierPath bezierPath];
	NSColor		*color;
	NSFont		*drawFont;
	NSTextStorage	*textStorage;
	NSLayoutManager	*layoutManager; 
	NSTextContainer	*textContainer;
	char		tmpCStr[2];
	NSRect		bounds;
	NSPoint		loc;
	NSGlyph		glyph = 0;
	BOOL		is_return = NO;
	
	[self myLockFocus];
	color = [[myController colorManager] randomColor];
	[color set];

	if ([myController useCapitals]) {
		if ((key >= 'a') && (key <= 'z')) {
			key -= 32;
		}
	}
	tmpCStr[0] = (char)key;
	tmpCStr[1] = 0;

	if (([myController mode] == MODE_ALPHABET) || 
					([myController mode] == MODE_LETTER)) {
		drawFont = [myController bigFont];
	} else {
		drawFont = [myController letterFont];
	}
	
	// Taken directly from CircleView
	textStorage = [[NSTextStorage alloc] initWithString:
		[NSString stringWithCString:tmpCStr 
			encoding:NSASCIIStringEncoding]];
	[textStorage setFont:drawFont];
	layoutManager = [[NSLayoutManager alloc] init]; 
	textContainer = [[NSTextContainer alloc] init]; 
	[layoutManager addTextContainer:textContainer];
	[textContainer release];
	[textStorage addLayoutManager:layoutManager];
	[layoutManager release];

	glyph = [layoutManager glyphAtIndex:0];

	if (([myController mode] == MODE_ALPHABET) || 
					([myController mode] == MODE_LETTER)) {
		bounds = [[myController bigFont] boundingRectForGlyph:glyph];
		loc.x = (myFrame.size.width - bounds.size.width) / 2.0;
		loc.y = (myFrame.size.height - bounds.size.height) / 2.0;
		drawFont = [myController bigFont];
	} else if ([myController mode] == MODE_TYPING) {
		loc = [self getTypingLocation:glyph isReturn:is_return];
		drawFont = [myController letterFont];
		if (!is_return) {
			[self updateTypingLocation:glyph];
		}
	} else {
		bounds = [[myController letterFont] boundingRectForGlyph:glyph];
		loc.x = rand_get_max(
				(int)(myFrame.size.width-bounds.size.width));
		loc.y = rand_get_max(
				(int)(myFrame.size.height-bounds.size.height));
		drawFont = [myController letterFont];
	}

	ABLog(@"drawing char %c at %f, %f", tmpCStr[0], loc.x, loc.y);
	[path moveToPoint:loc];
	[path appendBezierPathWithGlyph:glyph inFont:drawFont];
	[path fill];
	
	if ([drawFont pointSize] > 100.0) {
		[[NSColor blackColor] set];
		[path setLineWidth:10.0];
		[path stroke];
		[path setLineWidth:3.0];
		[[NSColor whiteColor] set];
		[path stroke];
		
	}
	
	[self myUnlockFocus];
	[textStorage release];
}

-(void)drawShapeOrImageAtPoint:(NSPoint)loc andCenter:(BOOL)center
{
	int action;
	float ratio;
	
	if ([myController onlyImages]) {
		action = 0;
	} else {
		ratio = [myController shapeImagesRatio];
		if (ratio == 0.0) {
			action = 1;
		} else if (ratio == 100.0) {
			action = 0;
		} else {
			action = rand_get_max(100);
			ABLog(@"action = %d, ratio = %f", action, ratio);
			if (action > ratio) {
				action = 1;
			} else {
				action = 0;
			}
		}
	}
	if ((action == 0) && ([myController numLoadedImages] > 0)) {
		[self drawImageAtPoint:loc andCenter:center];
	} else {
		[self drawShapeAtPoint:loc andCenter:center];
	}	
}

/* Draws a shape on the screen.  If the center argument is true, then the location supplied
 * is used as the center of the shape's location.  If center is false, then the supplied
 * location is ignored, and a random location within the screen is chosen.  If a random
 * location is used, the shape will always completely fit in the screen.  If a specified
 * location is used, the shape may not fit completely on the screen. A random color, size,
 * and shape are always chosen. 
 */
- (void)drawShapeAtPoint:(NSPoint)loc andCenter:(BOOL)center
{
	ShapeKind shapeKind = rand_get_max(SHAPE_MAX-1);
	NSSize size;
	NSColor *color;
	NSBezierPath *shapePath;
	NSAffineTransform *transform = [NSAffineTransform transform];
	NSRect outline;
	NSString *shapeName = @" ";

	color = [[myController colorManager] randomColor];
	
	shapePath = [NSBezierPath bezierPath];
	size.height = rand_get_range((int)(myFrame.size.height/5), (int)(myFrame.size.height/2));
	size.width = rand_get_range((int)(myFrame.size.width/5), (int)(myFrame.size.width/2));

	ABLog(@"about to draw shapeKind = %d", shapeKind);
	switch (shapeKind) {
		case SHAPE_CIRCLE: 
		case SHAPE_SQUARE:
		case SHAPE_HEART:
                case SHAPE_DIAMOND:
		case SHAPE_PENTAGON:
		case SHAPE_HEXAGON:
		case SHAPE_OCTAGON:
		case SHAPE_STAR:
		case SHAPE_MOON:
			size.height = size.width;
			break;
		case SHAPE_RECTANGLE:
		case SHAPE_OVAL:
			// Make sure width and height differ by 20%
			if (fabs(size.width - size.height) < (0.2 * size.width)) {
				if (size.width > size.height) {
					size.height = (size.width * 0.8);
				} else {
					size.width = (size.height * 0.8);
				}
			}
			break;
		default:
			break;
	}
	if (!center) {
		loc.x = rand_get_max((int)((myFrame.size.width-size.width)-5.0));
		loc.y = rand_get_max((int)((myFrame.size.height-size.height)-5.0));		
	} else {
		loc.x -= (size.width / 2);
		loc.y -= (size.height / 2);
	}

	if ([myController mode] == MODE_LETTER) {
		loc.x = (myFrame.size.width - size.width) / 2.0;
		loc.y = (myFrame.size.height - size.height) / 2.0;
	}

	outline.size = size;
	outline.origin = loc;

	[self myLockFocus];
	[shapePath moveToPoint:loc];
	
	// Just as a reminder as to how to use an image as a color
	//color = [NSColor colorWithPatternImage:pinkDot];
	[color set];
	switch (shapeKind) {
		case SHAPE_CIRCLE:
			[shapePath appendBezierPathWithOvalInRect:outline];
			shapeName = @"circle";
			break;
		case SHAPE_RECTANGLE:
			[shapePath appendBezierPathWithRect:outline];
			shapeName = @"rectangle";
			break;
		case SHAPE_SQUARE:
			[shapePath appendBezierPathWithRect:outline];
			shapeName = @"square";
			break;
		case SHAPE_OVAL:
			[shapePath appendBezierPathWithOvalInRect:outline];
			shapeName = @"oval";
			break;
		case SHAPE_HEART: 
			shapeName = @"heart";
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:size.width yBy:size.height];
			[shapePath removeAllPoints];
			[shapePath setLineJoinStyle:NSMiterLineJoinStyle];
			[shapePath moveToPoint:NSMakePoint(0.5, 0.6)];
			[shapePath curveToPoint:NSMakePoint(0.5, 0.1) controlPoint1:NSMakePoint(0.3, 1.0) controlPoint2:NSMakePoint(0.0, 0.5)];
			[shapePath curveToPoint:NSMakePoint(0.5, 0.6) controlPoint1:NSMakePoint(1.0, 0.5)
						controlPoint2:NSMakePoint(0.7, 1.0)];
			[shapePath closePath];
			break;
                case SHAPE_DIAMOND:
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:size.width yBy:size.height];
			[shapePath removeAllPoints];
			[shapePath moveToPoint:NSMakePoint(0.5, 0)];
			[shapePath lineToPoint:NSMakePoint(0, 0.5)];
			[shapePath lineToPoint:NSMakePoint(0.5, 1.0)];
			[shapePath lineToPoint:NSMakePoint(1.0, 0.5)];
			[shapePath lineToPoint:NSMakePoint(0.5, 0)];
			[shapePath closePath];
                        shapeName = @"rhombuss";
                        break;
		case SHAPE_TRIANGLE:
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:size.width yBy:size.height];
			[shapePath removeAllPoints];
			[shapePath moveToPoint:NSMakePoint(0,0)];
			[shapePath lineToPoint:NSMakePoint(0.5, 1.0)];
			[shapePath lineToPoint:NSMakePoint(1.0, 0)];
			[shapePath lineToPoint:NSMakePoint(0, 0)];
			[shapePath closePath];
			shapeName = @"triangle";
			break;
		case SHAPE_TRAPEZOID:
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:size.width yBy:size.height];
			[shapePath removeAllPoints];
			[shapePath moveToPoint:NSMakePoint(0, 0)];
			[shapePath lineToPoint:NSMakePoint(0.3, 1.0)];
			[shapePath lineToPoint:NSMakePoint(0.7, 1.0)];
			[shapePath lineToPoint:NSMakePoint(1.0, 0)];
			[shapePath lineToPoint:NSMakePoint(0, 0)];
			[shapePath closePath];
			shapeName = @"trapezoid";
			break;
		case SHAPE_PENTAGON:
			ABLog(@"Drawing pentagon %f, %f", loc.x, loc.y);
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:(size.width/2.0) yBy:(size.height/2.0)];
			[transform translateXBy:1.0 yBy:1.0];
			[self drawPolygonToPath:shapePath withSides:5 asStar:NO];
			shapeName = @"pentagon";
			break;
		case SHAPE_HEXAGON:
			ABLog(@"Drawing hexagon %f, %f", loc.x, loc.y);
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:(size.width/2.0) yBy:(size.height/2.0)];
			[transform translateXBy:1.0 yBy:1.0];
			[self drawPolygonToPath:shapePath withSides:6 asStar:NO];
			shapeName = @"hexagon";
			break;
		case SHAPE_OCTAGON:
			ABLog(@"Drawing octagon %f, %f", loc.x, loc.y);
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:(size.width/2.0) yBy:(size.height/2.0)];
			[transform translateXBy:1.0 yBy:1.0];
			[self drawPolygonToPath:shapePath withSides:8 asStar:NO];
			shapeName = @"octagon";
			break;
		case SHAPE_STAR:
			// Draws a star without interior lines
			ABLog(@"Drawing star %f, %f", loc.x, loc.y);
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:(size.width/2.0) yBy:(size.height/2.0)];
			[transform translateXBy:1.0 yBy:1.0];
			[self drawPolygonToPath:shapePath withSides:5 asStar:YES];
			shapeName = @"star";
			break;
		case SHAPE_MOON:
			ABLog(@"Drawing moon %f, %f", loc.x, loc.y);
			[transform translateXBy:loc.x yBy:loc.y];
			[transform scaleXBy:(size.width/2.0) yBy:(size.height/2.0)];
			[transform translateXBy:1.0 yBy:1.0];
			[transform rotateByDegrees:30.0];
			[shapePath removeAllPoints];
			[shapePath appendBezierPathWithArcWithCenter:NSMakePoint(0.0, 0.0)
						radius:1 startAngle:90.0 endAngle:270.0];
			[shapePath appendBezierPathWithArcWithCenter:NSMakePoint(1.0, 0.0)
							      radius:sqrt(2.0) startAngle:225.0 endAngle:135.0
							   clockwise:YES];
			[shapePath closePath];
			shapeName = @"moon";
			break;
		default:
			break;
	}
	ABLog(@"about to draw %@", shapeName);
	[[transform transformBezierPath:shapePath] fill];
		
	[[NSColor blackColor] set];
	[shapePath setLineWidth:10.0];

	[[transform transformBezierPath:shapePath] stroke];
	[shapePath setLineWidth:3.0];
	[[NSColor whiteColor] set];
	[[transform transformBezierPath:shapePath] stroke];

#ifdef SHOW_BOUNDING_BOX
	[shapePath removeAllPoints];
	[shapePath moveToPoint:loc];
	[shapePath appendBezierPathWithOvalInRect:NSMakeRect(loc.x-2, loc.y-2, 4, 4)];
	[[NSColor blackColor] set];
	[shapePath stroke];
	[shapePath removeAllPoints];
	[[NSColor redColor] set];
	[shapePath appendBezierPathWithRect:outline];
	[shapePath stroke];
#endif
	
	[self myUnlockFocus];
	[self playSoundForShape:shapeName];
}

- (void)drawPolygonToPath:(NSBezierPath *)path withSides:(int)numSides asStar:(BOOL)asStar
{
	float angle = M_PI * 2;
	float slice;
	int i;
	
	if (asStar) {
		slice = angle / (numSides * 2.0);
	} else {
		slice = angle / (numSides * 1.0);
	}
	[path removeAllPoints];
	[path moveToPoint:NSMakePoint(0, 1.0)];
	for (i = 0; i < numSides; i++) {
		angle -= slice;
		if (asStar) {
			[path lineToPoint:NSMakePoint((STAR_R*sin(angle)), (STAR_R*cos(angle)))];
			angle -= slice;
		}
		[path lineToPoint:NSMakePoint(sin(angle),cos(angle))];
	}
	[path closePath];
}

- (void)drawImageAtPoint:(NSPoint)loc andCenter:(BOOL)center
{
	NSImage *img;
	NSSize imgSize;
	NSRect dstRect;
	NSRect imgRect;

	if ([myController mapImages]) {
		img = [myController getMappedImageForKey:(keyPressed & 0xFF)];
	} else {
		img = [myController getRandomImage];	
	}
	
	ABLog(@"drawing image named %@", [img name]);
	imgSize = [img size];

	dstRect.size.width = imgSize.width;
	dstRect.size.height = imgSize.height;

	if (imgSize.height < (myFrame.size.height/5)) {
		dstRect.size.width = imgSize.width * 2;
		dstRect.size.height = imgSize.height * 2;
	} 
	
	while (dstRect.size.height > (myFrame.size.height/2)) {
		dstRect.size.width = dstRect.size.width / 2;
		dstRect.size.height = dstRect.size.height / 2;
	} 
	[img setScalesWhenResized:YES];
	[img setSize:dstRect.size];
	//[img recache];
	
	if (!center) {
		loc.x = rand_get_max((int)(myFrame.size.width-dstRect.size.width));
		loc.y = rand_get_max((int)(myFrame.size.height-dstRect.size.height));
	} else {
		loc.x -= (dstRect.size.width / 2);
		loc.y -= (dstRect.size.height / 2);
	}
	if ([myController mode] == MODE_LETTER) {
		loc.x = (myFrame.size.width - dstRect.size.width) / 2.0;
		loc.y = (myFrame.size.height - dstRect.size.height) / 2.0;
	}

	dstRect.origin.x = loc.x;
	dstRect.origin.y = loc.y;
        imgRect = NSMakeRect(0, 0, dstRect.size.width, dstRect.size.height);

	[self myLockFocus];
	//[img drawInRect:dstRect fromRect:imgRect operation:NSCompositeSourceAtop fraction:1.0];
	//[img drawInRect:dstRect fromRect:imgRect operation:NSCompositeSourceOver fraction:1.0];
	[img compositeToPoint:loc fromRect:imgRect operation:NSCompositeSourceOver fraction:1.0];
	[self myUnlockFocus];
        [self playSoundForImage:img];

}

- (void)updateDrawingWidths
{
	diam = myFrame.size.height * widths[[myController drawingWidth]];
	[NSBezierPath setDefaultLineWidth:
		(myFrame.size.height * widths[[myController drawingWidth]])];
	
	delta = (diam / 15.0) * -1.0;	
}

#pragma mark SOUND SUPPORT

- (void)playSound
{
	if ([myController enableSound] && eventFromUser) {
		NSSound *snd = [myController getRandomSound];
		if (snd) {
			ABLog(@"About to play sound %p", snd);
			[myController playSound:snd];
		}
	}
}

- (void)playSoundForLetter:(char)theLetter
{
	char letterStr[3];
	NSSound *snd;
	
	if ([myController matchLetters] && eventFromUser) {
		snd = [myController getSoundNamed:[NSString stringWithFormat:@"%c", theLetter]];
		if (snd) {
			[myController playSound:snd];
			return;
		}
	}
	if ([myController speakLetters] && eventFromUser) {
#ifdef OLD_SPEECH
                if ((theLetter == 'a') || (theLetter == 'A')) {
                        letterStr[0] = 2;
                        letterStr[1] = 'a';
                        letterStr[2] = 'y';
                } else {
                        letterStr[0] = 1;
                        letterStr[1] = theLetter;
                }
		SpeakString((ConstStr255Param)letterStr);
#else
		if (((theLetter == 'a') || (theLetter == 'A')) && ([[NSSpeechSynthesizer defaultVoice] compare:@"com.apple.speech.synthesis.voice.Alex"])) {
			[myController speakString:@"ay"];
		} else if ((theLetter == 'y') || (theLetter == 'Y')) {
			[myController speakString:@"wy"];
		} else {
			letterStr[0] = theLetter;
			letterStr[1] = 0;
			
			[myController speakString:
				[NSString stringWithCString:letterStr
					encoding:NSASCIIStringEncoding]];
		}
#endif
	} else {
		[self playSound];
	}
}

- (void)playSoundForShape:(NSString *)shapeName
{
	Str255 shapeStr;
#ifdef OLD_SPEECH
	Str255 colorStr;
#endif
	NSString *colorName;
	NSString *wholeName;
	
	if ([myController speakShapes] && eventFromUser) {
		if (((colorName = [[myController colorManager] getLastColorName]) != nil) && [myController speakColors]) {
			wholeName = [NSString stringWithFormat:@"%@ %@", colorName, shapeName];
#ifdef OLD_SPEECH
			if (CFStringGetPascalString((CFStringRef)wholeName,
						    colorStr, 256, kCFStringEncodingMacRoman)) {
				SpeakString(colorStr);
			}
#else
			[myController speakString:wholeName];
#endif
		} else if (CFStringGetPascalString((CFStringRef)shapeName,
					    shapeStr, 256, kCFStringEncodingMacRoman)) {
#ifdef OLD_SPEECH
			SpeakString(shapeStr);
#else
			[myController speakString:shapeName];
#endif
		}
	} else {
		[self playSound];
	}
}

- (void)playSoundForImage:(NSImage *)img
{
#ifdef OLD_SPEECH
        Str255 imageStr;
#endif
	NSSound *snd;
	NSString *name;
	
        if ([myController matchSounds] && eventFromUser) {
		snd = [myController getSoundNamed:[img name]];
		if (snd) {
			//[snd play];
			[myController playSound:snd];
			return;
		}
        }
	if ([myController speakImages] && eventFromUser) {
		if ([img name] != nil) {
			name = [[[img name] lastPathComponent] stringByDeletingPathExtension];
#ifdef OLD_SPEECH
			if (CFStringGetPascalString((CFStringRef)name,
						    imageStr, 256, kCFStringEncodingMacRoman)) {
				SpeakString(imageStr);
			}
#else
			[myController speakString:name];
#endif
                } else {
			ABLog(@"Got NIL image name!!");
		}
        } else {
                [self playSound];
        }
}

/* Routine is currently unused, may be used to play MIDI notes in the future.
 * Will need a separate thread to issue the stop sound
 */
- (void)playSomeNotes
{
#ifdef MUSIC_SUPPORTED
	NoteAllocator na;
	NoteChannel nc;
	NoteRequest nr;
	ComponentResult thisError;
	unsigned long t;
	BigEndianShort J = {2};           // Added to fix
        BigEndianFixed H = {0x00010000};  // compiler Error JJH

	na = 0;
	nc = 0;

	// Open up the note allocator.
	na = OpenDefaultComponent(kNoteAllocatorComponentType, 0);
	if (!na)
	goto goHome;

	// Fill out a NoteRequest using NAStuffToneDescription to help, and
	// allocate a NoteChannel.
	nr.info.flags = 0;
	nr.info.midiChannelAssignment = 0;
	// LJD - 2/7/06 - Removing these lines since they need to be fixed to work for universal binaries
	// since this routine isn't used anyway, not a big deal for  now.
	nr.info.polyphony = J; // simultaneous tones
	nr.info.typicalPolyphony = H; // usually just one note
	thisError = NAStuffToneDescription(na, 15, &nr.tone); // 1 is piano
	thisError = NANewNoteChannel(na, &nr, &nc);
	if (thisError || !nc)
		goto goHome;

	// If we've gotten this far, OK to play some musical notes. Lovely.
	NAPlayNote(na, nc, 60, 100); // middle C at velocity 80
	Delay(60, &t); // delay 2/3 of a second
	NAPlayNote(na, nc, 60, 0); // middle C at velocity 0: end note

goHome:
	if (nc)
		NADisposeNoteChannel(na, nc);
	if (na)
		CloseComponent(na);
#endif
}

#pragma mark MISCELLANEOUS

- (NSFont *)getDesiredFontSize:(float)desired fromFont:(NSFont *)font
{
	float fontSize = 0.0;
	NSRect bounds;
	NSString *fontName;
	NSFont *newFont = nil;
	
	fontName = [font fontName];
	bounds.size.height = 0.0;
	while (bounds.size.height < desired) {
		fontSize += 10.0;
		newFont = [NSFont fontWithName:fontName size:fontSize];
		bounds = [newFont boundingRectForFont];		
	}
	return newFont;
}

- (NSFont *) defaultFontForView
{
	NSString *fontName;
	float fontSize;
	float desired;
	NSFont *defFont;
	
	fontName = @"Arial-Black";
	fontSize = 12.0;

#ifdef ALPHABABY_SCREENSAVER
	desired = [[[NSScreen screens] objectAtIndex:0] frame].size.height 
									/ 3.0;
#else
	desired = myFrame.size.height / 3.0;
#endif
	defFont = [NSFont fontWithName:fontName size:fontSize];
	// Some fallback code in case Arial-Black doesn't exist on this system
	if (defFont == nil) {
		defFont = [NSFont userFontOfSize:fontSize];
		if (defFont == nil) {
			defFont = [NSFont systemFontOfSize:fontSize];
		}
	}
	return [self getDesiredFontSize:desired fromFont:defFont];
}

// Take the current font, but return a larger version of the 
// font which fills up half the screen (at least)
- (NSFont *)currentFontBig:(NSFont *)currentFont
{
	float desired;

	desired = myFrame.size.height / 1.5;
	ABLog(@"desired = %f, frame = (%f, %f)", desired, 
				myFrame.size.width, myFrame.size.height);
	return [self getDesiredFontSize:desired fromFont:currentFont];
}

- (void)setController:(Controller *)c
{
	myController = c;
}

- (void)showQuitInfo
{
	NSString *info = @"Use Option-Control-Command-Q or type q-u-i-t to quit\nUse Option-Control-Command-P or type p-r-e-f for preferences\nCommand-shift-C clears the screen";
	NSString *info2 = @"Type q-u-i-t to quit\nUse Option-Control-Command-P or type p-r-e-f for preferences\nCommand-shift-C clears the screen";
	NSString *theInfo;
	
	ABLog(@"PoundView showQuitInfo");
	[self myLockFocus];
	if ([myController quitKeysEnabled]) {
		theInfo = info;
	} else {
		theInfo = info2;
	}
	[theInfo drawAtPoint:NSMakePoint(10, 10) withAttributes:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:0], NSFontAttributeName,
			[NSColor blackColor], NSForegroundColorAttributeName, nil]];
	[self doRedraw];
	[self myUnlockFocus];
}

- (void)switchToMode:(int)mode
{
	if (mode == MODE_TYPING) {
		[self resetTypingLocation];
	}
}

/* Set the position for the next typed character to be in the upper left corner.
 */
- (void)resetTypingLocation
{
	NSRect bounds;
	
	bounds = [[myController letterFont] boundingRectForFont];
	typingLocation.x = 0;
	typingLocation.y = myFrame.size.height - bounds.size.height;
}

/* Given a letter (glyph) about to be drawn, look at the current typing location and determine
 * if it will fit on the same line, the next line, or not on the screen at all, necessitating a 
 * screen refresh.  The location where the letter should be drawn is returned, which could mean
 * modifying the current typing location.  This is called before the character is drawn.
 */
- (NSPoint)getTypingLocation:(NSGlyph)letter isReturn:(BOOL)isReturn
{
	NSSize movement;
	NSRect fontBounds;
	
	movement = [[myController letterFont] advancementForGlyph:letter];
	if (isReturn) {
		typingLocation.x = myFrame.size.width + 1;
	}
	if ((typingLocation.x + movement.width) <= myFrame.size.width) {
		return typingLocation;
	} else {
		fontBounds = [[myController letterFont] boundingRectForFont];
		typingLocation.x = 0;
		typingLocation.y -= fontBounds.size.height;
		if (typingLocation.y < 0) {
			typingLocation.y = myFrame.size.height - fontBounds.size.height;
			[self clearScreen];
		}
	}
	return typingLocation;
}

/*
 * Move the typing location to the next spot.  This is called after we get the location for
 * the current character, so it basically blindly advances one character to the right, with a 
 * width depedant on the size of the character, plus 5 pixels for some extra space.  Since we don't
 * know what character comes next, we don't worry about whether this new location will be valid
 * for the next character - that's handled in getTypingLocation.
 */
- (void)updateTypingLocation:(NSGlyph)letter
{
	NSSize movement;
	
	movement = [[myController letterFont] advancementForGlyph:letter];
	typingLocation.x += (movement.width+5);
}

// Screen Saver Part
#pragma mark SCREENSAVER SUPPORT

#ifdef ALPHABABY_SCREENSAVER
- (void)startAnimation
{
	ABLog(@"startAnimation: self window = %@", [self window]);
	if (myWindow == nil) {
		myWindow = [self window];
		[myController setupSaverWindow:self];
	}
	allowAnimation = NO;
	[self restartPauseTimer];
	[self clearScreen];
	[super startAnimation];
}

- (void)stopAnimation
{
	ABLog(@"stopAnimation");
	if ((startupPauseTimer != nil) && [startupPauseTimer isValid]) {
		[startupPauseTimer invalidate];
		[startupPauseTimer release];
		startupPauseTimer = nil;
	}
	[super stopAnimation];
}

- (void)animateOneFrame
{
	char letter[2];
	int action;
	NSPoint location;
	NSEvent *newEvent;
	
	if (!allowAnimation) {
		return;
	}
	action = rand_get_max(101);
	if (action < 40) {
		location.x = rand_get_max(myFrame.size.width);
		location.y = rand_get_max(myFrame.size.height);
		newEvent = [NSEvent mouseEventWithType:NSLeftMouseUp location:location
					 modifierFlags:0 timestamp:0 windowNumber:0 context:nil 
					   eventNumber:0 clickCount:1 pressure:1];
		[self handleMouseUp:newEvent fromUser:NO];
		ABLog(@"animateOneFrame: back from calling mouseUp");
	} else {
		letter[1] = 0;
		letter[0] = (char)rand_get_range('a', 'z');
		NSString *str = [NSString stringWithCString:letter
			encoding:NSASCIIStringEncoding];
		newEvent = [NSEvent keyEventWithType:NSKeyDown location:NSMakePoint(-99,-99) modifierFlags:0 timestamp:0 
						 windowNumber:0 context:nil characters:str 
				  charactersIgnoringModifiers:str isARepeat:NO keyCode:0];
		[self handleKeyDown:newEvent fromUser:NO];		
	}
}

- (BOOL)hasConfigureSheet
{
	return YES;
}

- (NSWindow*)configureSheet
{
	if ([myController prefsPanel] == nil) {
		[NSBundle loadNibNamed:@"AlphaScreenPrefs" owner:myController];
	}

	[myController setPreferencePanelValues];
	return [myController prefsPanel];
}

/* This routine starts a timer which controls when animation will begin.  It is called
 * when the screensaver first loads, to allow a pause before animation begins.  It is also
 * called whenever a user gives input to the screensaver, to allow user input to always override
 * automatic animation.  It stops any current animation, and restarts the pause timer.
 */ 
- (void)restartPauseTimer
{
	if (startupPauseTimer != nil) {
		if ([startupPauseTimer isValid]) {
			[startupPauseTimer invalidate];
		}
		[startupPauseTimer release];
		startupPauseTimer = nil;
	}
	startupPauseTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self 
							   selector:@selector(allowAnimation:) userInfo:nil repeats:NO];
	[startupPauseTimer retain];
	allowAnimation = NO;
}

/* Callback used by timer started in restartPauseTimer.  When it is called, the automatic animation
 * of shapes and letters is allowed whenever animateOneFrame is called.
 */
- (void)allowAnimation:(NSTimer *)timer
{
	allowAnimation = YES;
}

- (void)showScreenSaverQuitInfo
{
	NSString *info = @"Type q-u-i-t to quit";
	ABLog(@"PoundView showScreenSaverQuitInfo");
	[self myLockFocus];
	[info drawAtPoint:NSMakePoint(10, 10) withAttributes:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:0], NSFontAttributeName,
			[NSColor whiteColor], NSForegroundColorAttributeName, nil]];
	[self doRedraw];
	[self myUnlockFocus];
}

#endif

@end
