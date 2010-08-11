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

#import "Controller.h"
#import "krand.h"
#import "ABDebug.h"
#import "version.h"

/* 
 * Important flag which decides whether AlphaBaby will take over the whole screen or not
 * If set to 0, AlphaBaby runs in a 640x480 window, if set to 1 it takes over the whole
 * screen and prevents switching out.  Use FULLSCREEN 0 for debugging.  This define is
 * also set in the Debug-Small Screen build style (to 0)
 */
#ifndef FULLSCREEN
#define FULLSCREEN 0
#endif

/*
 * Helper routine used to sort names of images when images are loaded by the routine
 * loadImagesFromDirectory
 */
NSComparisonResult
compareImageNames(id img1, id img2, void *info)
{
	return [[img1 name] compare:[img2 name]];
}

/*
 * Implementation of Controller class.  This is the main class of AlphaBaby, which
 * handles startup, preferences, and cleanup.  In the application version of AlphaBaby,
 * a single Controller instance is created by the main NIB file.  In the screen saver
 * version, the screen saver view explicitly instantiates it.
 */

@implementation Controller

#pragma mark STATIC METHODS

/*
 * Early initialization method.  The static initialize method is called on the
 * Controller class before it is even created.  The only thing done is to create
 * and register defaults for all user preferences.  If a new preference is added,
 * it needs to be listed here with its default value.
 */

NSDictionary *initialUserDefaults;

+ (void) initialize
{
	static BOOL initialized = NO;
	NSUserDefaults *defaults;

	if (!initialized) {
		defaults = [Controller getDefaults];
		initialUserDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES],		@"SoundValue",
			[NSNumber numberWithBool:NO],		@"SpeakLettersValue",
			[NSNumber numberWithBool:NO],		@"SpeakShapesValue",
                        [NSNumber numberWithBool:NO],		@"SpeakImagesValue",
                        [NSNumber numberWithBool:NO],		@"MatchSoundsValue",
                        [NSNumber numberWithBool:NO],		@"MapImagesValue",
                        [NSNumber numberWithBool:NO],		@"OnlyImagesValue",
                        [NSNumber numberWithFloat:50.0],	@"ShapeImagesValue",
			[NSNumber numberWithInt:30],		@"RefreshValue",
			[NSNumber numberWithInt:1],		@"DisplayValue",
			@"",					@"ImageFolderValue",
			@"",					@"SoundFolderValue",
			[NSNumber numberWithBool:NO],		@"CapitalValue",
			[NSNumber numberWithBool:NO],		@"PunctuationValue",
			@"Arial-Black",				@"FontNameValue",
			[NSNumber numberWithFloat:12.0],	@"FontSizeValue",
			[NSNumber numberWithBool:YES],		@"DefaultFontValue",
			@"All",					@"ColorValue",
			[NSNumber numberWithInt:MODE_RANDOM],   @"ModeValue",
			[NSNumber numberWithBool:YES],		@"QuitKeysValue",
			[NSNumber numberWithInt:DRAW_STARS],    @"DrawingKindValue",
			[NSNumber numberWithInt:DRAWCOLOR_FIXED], @"DrawingColorKindValue",
			[NSArchiver archivedDataWithRootObject:[NSColor redColor]],
								@"DrawingColorValue",
			[NSArchiver archivedDataWithRootObject:[NSColor blackColor]],
								@"TextColorValue",
#ifdef ALPHABABY_SCREENSAVER
			[NSArchiver archivedDataWithRootObject:[NSColor blackColor]],
								@"BackgroundColorValue",
#else
			[NSArchiver archivedDataWithRootObject:[NSColor whiteColor]],
								@"BackgroundColorValue",
#endif
			[NSNumber numberWithBool:YES],		@"DrawingMouseValue",
			[NSNumber numberWithInt:2.0],		@"DrawingWidthValue",
			[NSNumber numberWithBool:NO],		@"MatchLettersValue",
			[NSNumber numberWithBool:NO],		@"SpeakColorsValue",
			[NSNumber numberWithBool:NO],		@"RandomAlbumValue",
			@"",					@"iPhotoAlbumValue",
			@"",					@"AlbumNameValue",
			nil];
		[initialUserDefaults retain];
		[defaults registerDefaults:initialUserDefaults];
		initialized = YES;
	}
}

/* In the application, the Controller object is created first, when the nib file
 * is loaded, and it eventually creates the PoundView objects.  In the screensaver
 * version, the PoundView object is created first, and must create the Controller
 * object on its own.  This method is used early in the initialization of the
 * screensaver to create the controller object, and do all the normal initialization.
 */
+ (Controller *)createController:(PoundView *)theView
{
	Controller *ctrl = [[Controller alloc] init];
	[ctrl doInitialization];
	return ctrl;
}

/* Static method to return the NSUserDefaults object for either the app or
 * screensaver.  Although they both use the same defaults object, they get it
 * in different ways.
 */
+ (NSUserDefaults *)getDefaults
{
#ifdef ALPHABABY_SCREENSAVER
	NSString *identifier = nil;
#endif
	NSUserDefaults *defaults;
	
#ifdef ALPHABABY_SCREENSAVER
	identifier = [[NSBundle bundleForClass:[Controller class]] bundleIdentifier];
	ABLog(@"Getting defaults for identifier %@", identifier);
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:identifier];
#else
	defaults = [NSUserDefaults standardUserDefaults];
#endif
	return defaults;
}

#pragma mark SETUP AND CLEANUP

/* Controller is the delegate of NSApplication, so it receives this notification
 * after the app has been loaded and initialized, but before events start being
 * sent.  All of our initialization is done from here.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{	
	[self doInitialization];
	[self createWindowsAndViews];
	[self beginFullScreen];
	//[self startActivityThread];
}

/* Common initialization, whether an app or screen saver.  This is mainly setting up
 * instance variables, and loading images and sounds if necessary.
 */
- (void)doInitialization
{
	NSUInteger albumIndex;
	
	// Initialize preference values
	[self initUserPreferences];
	
	soundIsPlaying = NO;
	imageDict = nil;
	soundDict = nil;
	mappedImageArray = (NSImage **)malloc(sizeof(NSImage *) * 256);
	
	quitChars = "quit";
	prefChars = "pref";
	currentQuitChar = 0;
	currentPrefChar = 0;
	quitTimerRunning = NO;
	quitTimer = nil;
	
	numItemsDrawn = 0;
	ABLog(@"Buildnum = %d, build date = %@", buildnum, builddate);
#ifdef ALPHABABY_DEBUG
	[versionString setStringValue:builddate];
#endif
	
#ifdef ALPHABABY_DEBUG
	keyNames = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:10], @"Escape",
				nil];
#endif
	// If we are loaded as a screen saver, colorManager will be nil right now
	if (colorManager == nil) {
		colorManager = [[ColorManager alloc] init];
	}
	
        [colorManager setCurrentColorSet:colorList];
	[colorManager updateFixedColor:textColor];
	if (![imageFolderPath isEqualToString:@""]) {
		[self loadImagesFromDirectory:imageFolderPath];
	}
	
	[self loadDefaultSounds];
	if (![soundFolderPath isEqualToString:@""]) {
		[self loadSoundsFromDirectory:soundFolderPath];
	}
	
	// If the user had previously specified an iPhoto album name, load it now, unless
	// they want a random album loaded.
	ABLog(@"iPhotoAlbum = %@, useRandomAlbum = %d", iPhotoAlbum, useRandomAlbum);
	if (![iPhotoAlbum isEqualToString:@""] || useRandomAlbum) {
		[self loadiPhotoAlbums];
		if (!useRandomAlbum) {
			// albumNameList has an extra "No Album" entry as the first item
			albumIndex = [albumNameList indexOfObject:iPhotoAlbum];
			if (albumIndex == 0) {
				// no albums to load...
				iPhotoAlbum = @"";
				albumIndex = NSNotFound;
			} else if (albumIndex != NSNotFound) {
				albumIndex -= 1;
			}
		} else {
			if ((albumList != nil) && ([albumList count] > 0)) {
				albumIndex = rand_get_max([albumList count]-1);				
				// Add 1 because albumPopup has an extra "No Albums" item
				iPhotoAlbum = [albumNameList objectAtIndex:(albumIndex+1)];
			} else {
				iPhotoAlbum = @"";
				albumIndex = NSNotFound;
			}
		}
		if (albumIndex != NSNotFound) {
			[self loadImagesFromAlbum:albumIndex];
			[imageFolderField setEnabled:NO];
			[imageFolderButton setEnabled:NO];
		}
	}
	
	if (speechSynth == nil) {
		speechSynth = [[NSSpeechSynthesizer alloc] init];
	}
#ifdef ALPHABABY_SCREENSAVER
	//[self setBackgroundColor:[NSColor blackColor]];
#else
	//[self setBackgroundColor:[NSColor whiteColor]];
#endif
}

/* The second step in Controller initialization in the application is to create the main window
 * and view.  This is the view that will take over the entire screen.  Multiple displays are also
 * handled here.
 */
- (void)createWindowsAndViews
{
	NSArray *screens;
	int i;
	NSScreen *mainScreen;
	PoundWindow *theWindow;
	PoundView *theView;
	NSRect screenRect;
        NSRect visibleRect;
        NSDictionary *devInfo;
       
	screenRect = NSMakeRect(100, 500, 640, 480);
	screens = [NSScreen screens];
	mainScreen = [NSScreen mainScreen];
	windowList = [NSMutableArray arrayWithCapacity:[screens count]];
	viewList = [NSMutableArray arrayWithCapacity:[screens count]];
        [windowList retain];
	[viewList retain];
	
	for (i = 0; i < [screens count]; i++) {
		// Put up a new window which is as big as the screen, and which has no title bar
		if (FULLSCREEN) {
                        screenRect = [[screens objectAtIndex:i] frame];
			if (([screens objectAtIndex:i] != mainScreen) &&
			    ((screenRect.origin.x == 0) && (screenRect.origin.y == 0))) {
				// Skip any screen that is not the main screen yet has an
				// origin at (0, 0).  Done to work around bug in mirroring
				// where two monitors appear to exist.
                                ABLog(@"Skipping overlapping window");
				continue;
			}
			theWindow = [[PoundWindow alloc] initWithContentRect:screenRect
								   styleMask:NSBorderlessWindowMask
								     backing:NSBackingStoreBuffered
								       defer:NO screen:nil/*[screens objectAtIndex:i]*/];
			origWindowLevel = [theWindow level];
			[theWindow setLevel:shieldWindowLevel];
			
		} else {
			theWindow = [[PoundWindow alloc] initWithContentRect:screenRect
								   styleMask:NSTitledWindowMask
								     backing:NSBackingStoreBuffered
								       defer:NO screen:[screens objectAtIndex:i]];
		}
                ABLog(@"screen %d, origin: %f, %f, size = %f, %f", i, screenRect.origin.x, screenRect.origin.y,
		      screenRect.size.width, screenRect.size.height);
                visibleRect = [[screens objectAtIndex:i] visibleFrame];
                devInfo = [[screens objectAtIndex:i] deviceDescription];
                ABLog([devInfo description]);
                ABLog(@"screen %d, visible rect origin: %f, %f, size = %f, %f", i, 
		      visibleRect.origin.x, visibleRect.origin.y,
		      visibleRect.size.width, visibleRect.size.height);
                
		
		[theWindow setBackgroundColor:[NSColor clearColor]]; //[self backgroundColor]];
		[theWindow makeKeyAndOrderFront:nil];
		[theWindow setDelegate:self];
		if (!useMouse) {
			[theWindow setAcceptsMouseMovedEvents:YES];
		}
		//  Load our content view
		theView = [[PoundView alloc] initWithFrame:screenRect andController:self];
		[theView setController:self];
		
		[theWindow setContentView:theView];
		if ([screens objectAtIndex:i] == mainScreen) {
			[theWindow makeFirstResponder:theView];
			mainWindow = theWindow;
			mainView = theView;
			if ([self defaultFont]) {
				letterFont = [theView defaultFontForView];
				[self setFontSize:[letterFont pointSize]];
				[self setFontName:[letterFont fontName]];
			} else {
				letterFont = [NSFont fontWithName:fontName size:fontSize];
			}
			bigFont = [theView currentFontBig:letterFont];
			[letterFont retain];
			[bigFont retain];
		}
				
		[windowList addObject:theWindow];
		[viewList addObject:theView];
	}
	[mainView switchToMode:mode];
        [mainWindow makeKeyAndOrderFront:nil];
}

/* This is a screensaver-only method.  The controller likes to have
 * a list of all windows and views. That information is not available
 * when a screensaver first starts up, so this method is called by
 * the screensaver when animation starts, so that the controller can
 * intialize all its window-related data structures.
 */
#ifdef ALPHABABY_SCREENSAVER
- (void)setupSaverWindow:(PoundView *)theView
{
	NSArray *screens;
	NSScreen *mainScreen;
	
	ABLog(@"setupSaverWindow");
	mainWindow = (PoundWindow *)[theView window];
	mainView = theView;
	if ([self defaultFont]) {
		ABLog(@"setting letterFont to defaultFont");
		letterFont = [theView defaultFontForView];
		[self setFontSize:[letterFont pointSize]];
		[self setFontName:[letterFont fontName]];
	} else {
		ABLog(@"setting letterFont to %@", fontName);
		letterFont = [NSFont fontWithName:fontName size:fontSize];
	}
	[self setBigFont:[theView currentFontBig:letterFont]];
	
	screens = [NSScreen screens];
	mainScreen = [NSScreen mainScreen];
	windowList = [NSMutableArray arrayWithCapacity:[screens count]];
	viewList = [NSMutableArray arrayWithCapacity:[screens count]];
        [windowList retain];
	[viewList retain];
	[letterFont retain];
	
	if (mainWindow != nil) {
		[windowList addObject:mainWindow];
		[viewList addObject:theView];
	}
	[NSCursor unhide];
}
#endif

#pragma mark ACTION METHODS

/* Controller's own private terminate action, sent by the Quit menu item
 * This is separate from the terminate method in the NSApplication class.
 * We need the menu item to call our own method, since we must first determine
 * if the control-option-command-Q way of quitting is enabled.
 */
- (IBAction)terminate:(id)sender
{
	if (quitKeysEnabled) {
		[[NSApplication sharedApplication] terminate:sender];
	}
}

/* Triggered by the Preferences menu item, this routine displays the preferences screen.
 * Since the normal AlphaBaby window sits on top of all other windows, we need to get
 * out of full screen mode before showing the preferences panel, otherwise it would be
 * hidden.  Before we show the panel, we set all of the controls to match the current
 * settings of all preference values.
 */
- (IBAction) showPreferences:(id)sender
{
	ABLog(@"showPreferences: enter");
	
	if (showingPrefs) {
		return;
	}
	[self setPreferencePanelValues];
	[self endFullScreen];
	
	ABLog(@"showPreferences: calling runModalForWindow");
	[prefsPanel makeKeyAndOrderFront:nil];
	ABLog(@"showPreferences: back from runModalForWindow");
	showingPrefs = YES;
}

// The user closed the preferences panel, and we want to save any changes
- (IBAction) preferencesDone:(id)sender
{
	ABLog(@"preferencesDone");
	if (newFont != letterFont) {
		[self setLetterFont:newFont];
		defaultFont = NO;
		fontName = [newFont fontName];
		[self setFontName:[newFont fontName]];
		fontSize = [newFont pointSize];
		[self setBigFont:[mainView currentFontBig:letterFont]];
	}
	
	ABLog(@"deal with new image folder");
	if (newImageFolderPath != nil) {
		if (newImageFolderPath != @"") {
			[self loadImagesFromDirectory:newImageFolderPath];
			imageFolderPath = newImageFolderPath;
		} else {
			if (imageList != nil) {
				[imageList removeAllObjects];
				[imageList release];
				imageList = nil;
			}
			imageFolderPath = @"";
		}
	}
	
	if ([albumPopup indexOfSelectedItem] != oldAlbumIndex) {
		if ([albumPopup indexOfSelectedItem] > 0) {
			[self loadImagesFromAlbum:[albumPopup indexOfSelectedItem]-1];			
		} else if (((newImageFolderPath == @"") || (newImageFolderPath == nil)) && (imageList != nil)) {
			[imageList removeAllObjects];
			[imageList release];
			imageList = nil;
			// If we had an old image folder path sitting there and no more album
			// selected, reload the image folder path
			if ((imageFolderPath != nil) && (imageFolderPath != @"")) {
				[self loadImagesFromDirectory:imageFolderPath];
			}
		}
	}
	
	ABLog(@"deal with new sound folder");
	if (newSoundFolderPath != nil) {
		if (newSoundFolderPath != @"") {
			[self loadSoundsFromDirectory:newSoundFolderPath];
			soundFolderPath = newSoundFolderPath;
		} else {
			if (soundList != nil) {
				[soundList removeAllObjects];
				[soundList release];
				soundList = nil;
			}
			soundFolderPath = @"";
		}
	}
	
	if (newFixedColor && (newFixedColor != textColor)) {
		if (textColor) {
			[textColor release];
			textColor = newFixedColor;
		}
		[colorManager updateFixedColor:textColor];
	}
	
	ABLog(@"calling getPreferencePanelValues");
	[self getPreferencePanelValues];
	ABLog(@"calling saveUserPreferences");
	[self saveUserPreferences];
	ABLog(@"calling colorManager setCurrentColorSet");
	[colorManager setCurrentColorSet:colorList];
	
	showingPrefs = NO;
        ABLog(@"about to close prefsPanel");
#ifdef ALPHABABY_SCREENSAVER
	ABLog(@"endSheet since screensaver");
	[NSApp endSheet:prefsPanel];
#else
	[prefsPanel close];
#endif
        ABLog(@"Prefs panel closed");
	[[[NSFontManager sharedFontManager] fontPanel:YES] close];
	[self beginFullScreen];
	ABLog(@"prefsDone returning");
}

// The  user closed the preferences panel, and we want to ignore any changes
- (IBAction) preferencesCancel:(id)sender
{
	showingPrefs = NO;
#ifdef ALPHABABY_SCREENSAVER
	[NSApp endSheet:prefsPanel];
#else
	[prefsPanel close];
#endif
	[[[NSFontManager sharedFontManager] fontPanel:YES] close];
	[self beginFullScreen];
}

- (IBAction) displayFontPanel:(id)sender
{
	ABLog(@"In setLetterFont");
		// The following line is needed so that the changeFont message
		// is sent to us when the user changes the font
	//[[fontNameField window] makeFirstResponder:[fontNameField window]];
	[[NSFontManager sharedFontManager] setTarget:self];
	[[NSFontManager sharedFontManager] setSelectedFont:letterFont isMultiple:NO];
	[[NSFontManager sharedFontManager] orderFrontFontPanel:self];
}

- (IBAction) setClearScreen:(id)sender
{
	ABLog(@"setClearScreen called with tag %d", [sender selectedTag]);
	if ([sender selectedTag] == 1) {
		[clearItemsTextField setEnabled:NO];
	} else {
		[clearItemsTextField setEnabled:YES];
	}
	
}

- (IBAction) clickedOnlyImages:(id)sender
{
	if ([sender state] == NSOnState) {
		[mapImagesCheckbox setEnabled:YES];
	} else {
		[mapImagesCheckbox setEnabled:NO];
	}
}

- (IBAction) setImageFolder:(id)sender
{
	NSOpenPanel *openPanel;
	int retVal;
	
	ABLog(@"setImageFolder");
	[[sender window] makeFirstResponder:[sender window]];
	openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setAllowsMultipleSelection:NO];
	retVal = [openPanel runModalForTypes:nil];
	if (retVal == NSOKButton) {
		// A directory has been chosen
		newImageFolderPath = [[openPanel filenames] objectAtIndex:0];
		[newImageFolderPath retain]; // TODO
		[imageFolderField setStringValue:newImageFolderPath];
	}
	
}

- (IBAction) setSoundFolder:(id)sender
{
	NSOpenPanel *openPanel;
	int retVal;
	
	ABLog(@"setSoundFolder");
	[[sender window] makeFirstResponder:[sender window]];
	openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setAllowsMultipleSelection:NO];
	retVal = [openPanel runModalForTypes:nil];
	if (retVal == NSOKButton) {
		// A directory has been chosen
		newSoundFolderPath = [[openPanel filenames] objectAtIndex:0];
		[newSoundFolderPath retain]; // TODO
		[soundsFolderField setStringValue:newSoundFolderPath];
	}	
}

- (IBAction) clearImageFolder:(id)sender
{
	[imageFolderField setStringValue:@""];
	newImageFolderPath = @"";
	[onlyImagesCheckbox setState:NSOffState];
	[mapImagesCheckbox setState:NSOffState];
	[mapImagesCheckbox setEnabled:NO];
}


- (IBAction) setSound:(id)sender
{
	ABLog(@"setSound called");
	ABLog([sender description]);
}

- (IBAction) showQuitInfo:(id)sender
{
	[[mainWindow contentView] showQuitInfo];
}

- (IBAction)showAbout:(id)sender
{
#ifdef ALPHABABY_SCREENSAVER
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSImage *icon = [NSImage imageNamed:[bundle objectForInfoDictionaryKey:@"CFBundleIconFile"]];
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
		@"AlphaBabySaver", @"ApplicationName",
		icon, @"ApplicationIcon",
		//@"Version",
		//@"Copyright",
		//@"ApplicationVersion",
		//@"Credits",
		nil];
	
	[NSApp orderFrontStandardAboutPanelWithOptions:options];
#else
	[NSApp orderFrontStandardAboutPanel:sender];
#endif
}

- (IBAction)resetFont:(id)sender
{
	//newFont = [[mainWindow contentView] defaultFontForView];
	newFont = [mainView defaultFontForView];
	[fontNameField setStringValue:[NSString stringWithFormat:@"%@ %.1f",
		[newFont fontName], [newFont pointSize]]];
	[[NSFontManager sharedFontManager] setSelectedFont:newFont isMultiple:NO];
}

// Called when user is in the preferences screen, to reset all preference field values back to their
// default states.
// so, we have a NSDictionary in "initialize" which contains the defaults (except for the default font
// size, which must be computed), but it is local to that routine. 
// initUserPreferences will set our instance variables to values from defaults, except that it doesn't take
// a passed-in defaults - it just gets it from Controller.  So, we would have to reset our defaults from
// the controller before we called it.  This action is going to be non-undoable.
// next, we must set the actual controls to the right values based on our new instance vars, which is in
// setPreferencePanelValues.  So, last thing to do is reset font size.
// BUT.. we are not actually clearing out the image or sound lists internally, even though they don't
// show up in the preferences window anymore.
- (IBAction)resetPreferences:(id)sender
{
	NSUserDefaults *defaults = [Controller getDefaults];
	
	// This line wipes out any data read in from the com.alphababy.plist file
	[defaults removePersistentDomainForName:@"com.alphababy"];
	[defaults synchronize];
	
	[self initUserPreferences];
	[self setLetterFont:[[mainWindow contentView] defaultFontForView]];
	[self setFontSize:[letterFont pointSize]];
	[self setFontName:[letterFont fontName]];
	if (soundList != nil) {
		[soundList removeAllObjects];
		[soundList release];
		soundList = nil;
	}
	if (imageList != nil) {
		[imageList removeAllObjects];
		[imageList release];
		imageList = nil;
	}
	[albumPopup selectItemAtIndex:0];
	[self setPreferencePanelValues];
}

- (IBAction)clearSoundFolder:(id)sender
{
	[soundsFolderField setStringValue:@""];
	newSoundFolderPath = @"";	
}

- (IBAction)clearScreen:(id)sender
{
	int i;
	for (i = 0; i < [windowList count]; i++) {
		[[[windowList objectAtIndex:i] contentView] clearScreen];
	}
	numItemsDrawn = 0;
}

NSString *labels[] = {
	@"Skinny",
	@"Thin",
	@"Medium",
	@"Thick",
	@"Jumbo"
};

- (IBAction)updateLineWidthLabel:(id)sender
{
	[drawingLineWidthLabel setStringValue:labels[[sender intValue]]];
}

/*
 * Sent when the user selects and album from the popup list of iPhoto albums
 */
- (IBAction)albumChosen:(id)sender
{

	if ([albumPopup indexOfSelectedItem] > 0) {
		ABLog(@"Album chosen, disabling image fields");
		[imageFolderField setEnabled:NO];
		[imageFolderButton setEnabled:NO];
	} else {
		ABLog(@"No Album chosen, enabling image fields");
		[imageFolderField setEnabled:YES];
		[imageFolderButton setEnabled:YES];
	}
}

/*
 * When the user selects "Fixed Color..." from the colors popup menu
 */
- (IBAction)setFixedColor:(id)sender
{
	NSColorPanel	*colorPanel;
	//[[NSApplication sharedApplication] orderFrontColorPanel:nil];
	ABLog(@"setFixedColor");
	colorPanel = [NSColorPanel sharedColorPanel];
	[colorPanel setTarget:self];
	[colorPanel setAction:@selector(changeColor:)];
	[colorPanel orderFront:nil];
}

#pragma mark MISCELLANEOUS

- (void)startActivityThread
{
	activityTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(insertRandomEvent:) userInfo:nil repeats:YES];
}

- (void)insertRandomEvent:(NSTimer *)timer
{
	char letter[2];
	
	letter[1] = 0;
	letter[0] = (char)rand_get_range('a', 'z');
	NSString *str = [NSString stringWithCString:letter
		encoding:NSASCIIStringEncoding];
	NSApplication *app = [NSApplication sharedApplication];
	NSEvent *newEvent = [NSEvent keyEventWithType:NSKeyDown location:NSMakePoint(0,0) modifierFlags:0 timestamp:0 
					 windowNumber:0 context:nil characters:str 
			  charactersIgnoringModifiers:str isARepeat:NO keyCode:0];
	[app postEvent:newEvent atStart:NO];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{	
	[self endFullScreen];
}

- (void)beginFullScreen
{
#ifndef ALPHABABY_SCREENSAVER
	int i;
	
	if (FULLSCREEN) {
		if (CGCaptureAllDisplays() != kCGErrorSuccess) {
			ABLog(@"Couldn't capture the main display!");
			NSRunCriticalAlertPanel(@"AlphaBaby Alert", 
						@"Could not take over entire screen",
						@"Quit", nil, nil);
			exit(0);
		}
		shieldWindowLevel = CGShieldingWindowLevel();
		ABLog(@"shieldWindowLevel = %d", shieldWindowLevel);
		for (i = ([windowList count]-1); i >= 0; i--) {
			[[windowList objectAtIndex:i] setLevel:shieldWindowLevel];
		}
		[mainWindow makeKeyAndOrderFront:nil];		
	}
	if (FULLSCREEN) {
		OSStatus error;
		
		GetSystemUIMode(&uiMode, &uiOpts); // save for later
		
		error = SetSystemUIMode(kUIModeAllHidden,
					kUIOptionDisableAppleMenu
					| kUIOptionDisableProcessSwitch
					| kUIOptionDisableForceQuit
					| kUIOptionDisableSessionTerminate);
		
	}
#endif
}

- (void)endFullScreen
{
#ifndef ALPHABABY_SCREENSAVER
	int i;
	
	if (FULLSCREEN) {
		if (CGReleaseAllDisplays() != kCGErrorSuccess) {
			ABLog(@"Couldn't release the display(s)!");
			NSRunCriticalAlertPanel(@"AlphaBaby Alert", 
						@"Could not release full screen mode",
						@"Quit", nil, nil);
			exit(0);			
		}
		for (i = 0; i < [windowList count]; i++) {
			[[windowList objectAtIndex:i] setLevel:origWindowLevel];
		}
        }
	if (FULLSCREEN) {
		SetSystemUIMode(uiMode, uiOpts);
	}
#endif
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification
{
        int i;
        
        ABLog(@"window became key: %@", [[aNotification object] description]);
        for (i = 0; i < [windowList count]; i++) {
            if ([aNotification object] == [windowList objectAtIndex:i]) {
		ABLog(@"a main window became key");
		if (showingPrefs) {
			[self preferencesDone:self];
		}
                return;
            }
        }
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool
{
	soundIsPlaying = NO;
	//[playingSound release];
	//[sound release];
	ABLog(@"++in sound:%p didFinishPlaying:%d", sound, (int)aBool);
	if (sound == playingSound) {
		ABLog(@"++stopped sound %p == playingSound %p", sound, playingSound);
		playingSound = nil;
	}
	if (aBool) {
		// To match the retain we put in during playSound
		//[sound release];
		ABLog(@"++released sound %p since it finished normally", sound);
	}
	ABLog(@"++sound %p finished %d with retain count %d", sound, (int)aBool, [sound retainCount]);
	//playingSound = nil;
}

- (void)playSound:(NSSound *)snd
{
#if 0
	NSSound *saveSound;
	if (playingSound == snd) {
		ABLog(@"++about to play same sound that is already playing: %p", snd);
	}
	if (soundIsPlaying) {
		if ([playingSound isPlaying]) {
			ABLog(@"++soundIsPlaying is true, playingSound = %p, about to stop it", playingSound);
			saveSound = playingSound;
			//[playingSound stop];
			ABLog(@"++stopped sound %p from playing in playSound", saveSound);
		}
		//[playingSound stop];
		soundIsPlaying = NO;
		playingSound = nil;
	}
#endif
	//if (!soundIsPlaying) {
	ABLog(@"++playing sound %p with retain count %d", snd, [snd retainCount]);
	//[snd setDelegate:self];
	//[snd retain];
	if (0) {
		playingSound = [[snd copy] autorelease];
		[playingSound play];
		
	} else {
		[snd play];
	}
	ABLog(@"++after play sound %p with retain count %d", playingSound, [playingSound retainCount]);
	//playingSound = snd;
	//ABLog(@"retained sound %p", playingSound);
	//[playingSound retain];
	soundIsPlaying = YES;
	//}
	
}

- (int)currentAlphabetChar
{
	if (currentAlphabetChar == ('z'+1)) {
		currentAlphabetChar = '0';
	} else if (currentAlphabetChar == ('9'+1)) {
		currentAlphabetChar = 'a';
	}
	return currentAlphabetChar++;
}

/*
 Logic for the quit timer:
 
 */
- (BOOL)checkQuitCharacter:(int)c
{
	ABLog(@"checkQuitCharacter: c = %c", c);
	if (isalpha(c)) {
		c = tolower(c);
		ABLog(@"currentQuitChar = %d", currentQuitChar);
		if ((char)c == quitChars[currentQuitChar]) {
			ABLog(@"matched quit char %c", c);
			if (currentQuitChar == 0) {
				if ((quitTimer != nil) && ([quitTimer isValid])) {
					[quitTimer invalidate];
				}
				ABLog(@"Starting quit timer");
				quitTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(quitTimerExpired:) userInfo:nil repeats:NO];
				quitTimerRunning = YES;
			}
			++currentQuitChar;
			currentPrefChar = 0;
			ABLog(@"Got a valid quit char");
			if (currentQuitChar == 4) {
				ABLog(@"About to quit!");
#ifndef ALPHABABY_SCREENSAVER
				[[NSApplication sharedApplication] terminate:self];
#endif
				return YES;
			}
		} else if ((char)c == prefChars[currentPrefChar]) {
			if (currentPrefChar == 0) {
				if ((quitTimer != nil) && [quitTimer isValid]) {
					[quitTimer invalidate];
				}
				quitTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(quitTimerExpired:) userInfo:nil repeats:NO];
				quitTimerRunning = YES;
			}
			++currentPrefChar;
			currentQuitChar = 0;
			if (currentPrefChar == 4) {
#ifndef ALPHABABY_SCREENSAVER
				[self showPreferences:self];
#endif
			}
		} else {
			ABLog(@"didn't match: wanted %c got %c", quitChars[currentQuitChar], c);
			[self quitTimerExpired:quitTimer];
		}
	} else {
		[self quitTimerExpired:quitTimer];
	}
	return NO;
}

- (void)quitTimerExpired:(NSTimer *)timer
{
	if ((timer != nil) && [timer isValid]) {
		ABLog(@"Timer expired!");
		[timer invalidate];
		quitTimer = nil;
	}
	currentQuitChar = 0;
	currentPrefChar = 0;
	quitTimerRunning = NO;
}

- (BOOL)needsRefresh
{
	if (mode == MODE_TYPING) {
		// Typing mode always fills up the screen, and ignores the refresh count.
		return NO;
	}
	if (((refreshCount > 0) && (numItemsDrawn >= refreshCount)) || ((mode == MODE_ALPHABET) || (mode == MODE_LETTER))) {
		numItemsDrawn = 0;
		return YES;
	}
	return NO;
}

- (PoundView *)getRandomView
{
	int i;
	
	if ([windowList count] == 1) {
		ABLog(@"getRandomView: Returning main content view");
		return [mainWindow contentView];
	} 
	i = rand_get_max([windowList count]-1);
	ABLog(@"getRandomView:returning view %d", i);
	return [[windowList objectAtIndex:i] contentView];
}

- (NSImage *)getMappedImageForKey:(int)key
{
	if ((imageList == nil) || ([imageList count] == 0)) {
		return nil;
	}
	return mappedImageArray[key];
}

- (NSImage *)getRandomImage
{
	int imgNum;
	
	if ((imageList == nil) || ([imageList count] == 0)) {
		return nil;
	}
	imgNum = rand_get_max([imageList count] - 1);
	if ([[imageList objectAtIndex:imgNum] isValid]) {
		return [imageList objectAtIndex:imgNum];		
	}
	return nil;
}

- (NSSound *)getRandomSound
{
	int sndNum;
	
	if ((soundList != nil) && ([soundList count] > 0)) {
		sndNum = rand_get_max([soundList count]-1);
		ABLog(@"Returning soundlist sound #%d", sndNum);
		return [soundList objectAtIndex:sndNum];
	} else if ((defaultSoundList != nil) &&
				([defaultSoundList count] > 0)) {
		sndNum = rand_get_max([defaultSoundList count]-1);
		ABLog(@"Returning default sound %d (out of %d)", sndNum,
			[defaultSoundList count]);
		return [defaultSoundList objectAtIndex:sndNum];
	}
	return nil;
}

- (NSSound *)getSoundNamed:(NSString *)name
{
	if (soundDict != nil) {
		return [soundDict objectForKey:name];
	}
	return nil;
}

- (void)speakString:(NSString *)str
{
	[speechSynth startSpeakingString:str];
}

#pragma mark PREFERENCE MANAGEMENT

// Set instance variables for user preferences from the saved Preferences
- (void)initUserPreferences
{
	NSUserDefaults *defaults = [Controller getDefaults];
	
	refreshCount = [defaults integerForKey:@"RefreshValue"];
	displayCount = [defaults integerForKey:@"DisplayValue"];
	enableSound = [defaults boolForKey:@"SoundValue"];
	speakLetters = [defaults boolForKey:@"SpeakLettersValue"];
	speakShapes = [defaults boolForKey:@"SpeakShapesValue"];
	speakImages = [defaults boolForKey:@"SpeakImagesValue"];
	matchSounds = [defaults boolForKey:@"MatchSoundsValue"];
	mapImages = [defaults boolForKey:@"MapImagesValue"];
	onlyImages = [defaults boolForKey:@"OnlyImagesValue"];
	shapeImagesRatio = [defaults floatForKey:@"ShapeImagesValue"];
	fontName = [defaults stringForKey:@"FontNameValue"];
	fontSize = [defaults floatForKey:@"FontSizeValue"];
	imageFolderPath = [defaults stringForKey:@"ImageFolderValue"];
	defaultFont = [defaults boolForKey:@"DefaultFontValue"];
	useCapitals = [defaults boolForKey:@"CapitalValue"];
	usePunctuation = [defaults boolForKey:@"PunctuationValue"];
	soundFolderPath = [defaults stringForKey:@"SoundFolderValue"];
	colorList = [defaults stringForKey:@"ColorValue"];
	[self setMode:[defaults integerForKey:@"ModeValue"]];
	quitKeysEnabled = [defaults boolForKey:@"QuitKeysValue"];
	drawingKind = [defaults integerForKey:@"DrawingKindValue"];
	drawingColorKind = [defaults integerForKey:@"DrawingColorKindValue"];
	[self readColorFromDefaults:@"DrawingColorValue"
						toColor:&(drawingColor) withDefault:[NSColor redColor]];
	[self readColorFromDefaults:@"TextColorValue"
						toColor:&(textColor) withDefault:[NSColor blackColor]];
	[self readColorFromDefaults:@"BackgroundColorValue"
						toColor:&(backgroundColor) withDefault:[NSColor clearColor]];	
	drawingWidth = [defaults integerForKey:@"DrawingWidthValue"];
	useMouse = [defaults boolForKey:@"DrawingMouseValue"];
	matchLetters = [defaults boolForKey:@"MatchLettersValue"];
	speakColors = [defaults boolForKey:@"SpeakColorsValue"];
	useRandomAlbum = [defaults boolForKey:@"RandomAlbumValue"];
	iPhotoAlbum = [defaults stringForKey:@"iPhotoAlbumValue"];
	ABLog(@"iPhotoAlbum = %@", iPhotoAlbum);
	
	[fontName retain];
	[imageFolderPath retain];
	[soundFolderPath retain];
	[colorList retain];
	[iPhotoAlbum retain];
}

// Set saved Preferences based on current state of instance variables
- (void)saveUserPreferences
{
	NSUserDefaults *defaults = [Controller getDefaults];

	[defaults setInteger:refreshCount forKey:@"RefreshValue"];
	[defaults setInteger:displayCount forKey:@"DisplayValue"];
	[defaults setBool:enableSound forKey:@"SoundValue"];
	[defaults setBool:speakLetters forKey:@"SpeakLettersValue"];
	[defaults setBool:speakShapes forKey:@"SpeakShapesValue"];
	[defaults setBool:speakImages forKey:@"SpeakImagesValue"];
	[defaults setBool:matchSounds forKey:@"MatchSoundsValue"];
	[defaults setBool:mapImages forKey:@"MapImagesValue"];
	[defaults setBool:onlyImages forKey:@"OnlyImagesValue"];
	[defaults setFloat:shapeImagesRatio forKey:@"ShapeImagesValue"];
	[defaults setObject:fontName forKey:@"FontNameValue"];
	[defaults setFloat:fontSize forKey:@"FontSizeValue"];
	[defaults setBool:defaultFont forKey:@"DefaultFontValue"];
	[defaults setObject:imageFolderPath forKey:@"ImageFolderValue"];
	[defaults setBool:useCapitals forKey:@"CapitalValue"];
	[defaults setBool:usePunctuation forKey:@"PunctuationValue"];
	[defaults setObject:soundFolderPath forKey:@"SoundFolderValue"];
	[defaults setObject:colorList forKey:@"ColorValue"];
	[defaults setInteger:mode forKey:@"ModeValue"];
	[defaults setBool:quitKeysEnabled forKey:@"QuitKeysValue"];
	[defaults setInteger:drawingKind forKey:@"DrawingKindValue"];
	[defaults setInteger:drawingColorKind forKey:@"DrawingColorKindValue"];
	[defaults setObject:[NSArchiver archivedDataWithRootObject:drawingColor] forKey:@"DrawingColorValue"];
	[defaults setObject:[NSArchiver archivedDataWithRootObject:textColor] forKey:@"TextColorValue"];
	[defaults setObject:[NSArchiver archivedDataWithRootObject:backgroundColor] forKey:@"BackgroundColorValue"];
	[defaults setBool:useMouse forKey:@"DrawingMouseValue"];
	[defaults setInteger:drawingWidth forKey:@"DrawingWidthValue"];
	[defaults setBool:matchLetters forKey:@"MatchLettersValue"];
	[defaults setBool:speakColors forKey:@"SpeakColorsValue"];
	[defaults setBool:useRandomAlbum forKey:@"RandomAlbumValue"];
	[defaults setObject:iPhotoAlbum forKey:@"iPhotoAlbumValue"];
	
	// Technically, this isn't really needed, but the ScreenSaver sometimes doesn't
	// see the changed defaults.
	[defaults synchronize];
}

// Set the user interface elements in the preferences panel useing our instance vars
- (void)setPreferencePanelValues
{
	[soundCheckbox setState:(enableSound ? NSOnState : NSOffState)];
	[speakLettersCheckbox setState:(speakLetters ? NSOnState : NSOffState)];
	[speakShapesCheckbox setState:(speakShapes ? NSOnState: NSOffState)];
	[speakImagesCheckbox setState:(speakImages ? NSOnState : NSOffState)];
	[capitalCheckbox setState:(useCapitals ? NSOnState: NSOffState)];
	[punctuationCheckbox setState:(usePunctuation ? NSOnState: NSOffState)];
	[matchSoundsCheckbox setState:(matchSounds ? NSOnState : NSOffState)];
	[onlyImagesCheckbox setState:(onlyImages ? NSOnState : NSOffState)];
	[mapImagesCheckbox setState:(mapImages ? NSOnState : NSOffState)];
	[quitCommandCheckbox setState:(quitKeysEnabled ? NSOnState : NSOffState)];
	[speakColorsCheckbox setState:(speakColors ? NSOnState : NSOffState)];
	[matchLettersCheckbox setState:(matchLetters ? NSOnState : NSOffState)];
	[drawingMouseCheckbox setState:(useMouse ? NSOnState : NSOffState)];
	[randomAlbumCheckbox setState:(useRandomAlbum ? NSOnState : NSOffState)];
	if (mapImages && onlyImages) {
		[mapImagesCheckbox setEnabled:YES];
	}
     
	[shapeImagesSlider setFloatValue:shapeImagesRatio];
	 
	if (refreshCount == 0) {
		[clearItemsRadio selectCellWithTag:1];
		[clearItemsTextField setEnabled:NO];
	} else {
		[clearItemsRadio selectCellWithTag:0];
		[clearItemsTextField setIntValue:refreshCount];
		[clearItemsTextField setEnabled:YES];
	}
	[displayItemsTextField setIntValue:displayCount];
	
	[imageFolderField setStringValue:imageFolderPath];
	[soundsFolderField setStringValue:soundFolderPath];
	[fontNameField setStringValue:[NSString stringWithFormat:@"%@ %.1f",
		fontName, fontSize]];
	[colorPopup selectItemWithTitle:colorList];
	[modePopup selectItemAtIndex:mode];
	[drawingColorWell setColor:drawingColor];
	[backgroundColorWell setColor:backgroundColor];
	[self setFixedColorMenuItem:textColor];
	[drawingKindRadio selectCellWithTag:drawingKind];
	[drawingColorRadio selectCellWithTag:drawingColorKind];
	[drawingLineWidthSlider setIntValue:drawingWidth];
	[self updateLineWidthLabel:drawingLineWidthSlider];
	if (albumList == nil) {
		[self loadiPhotoAlbums];
	}
	if ([albumPopup numberOfItems] != [albumNameList count]) {
		[albumPopup addItemsWithTitles:albumNameList];
	}	
	
	if ((iPhotoAlbum != nil) && ([iPhotoAlbum length] > 0)) {
		[albumPopup selectItemWithTitle:iPhotoAlbum];
	}
	
	// Temporary values to determine if something changes during prefs
	newFont = letterFont;
	newImageFolderPath = nil;
	newSoundFolderPath = nil;
	newFixedColor = nil;
	oldAlbumIndex = [albumPopup indexOfSelectedItem];
}

- (void)readColorFromDefaults:(NSString *)defaultName toColor:(NSColor **)colorPtr
	withDefault:(NSColor *)defColor
{
	NSUserDefaults *defaults = [Controller getDefaults];
	NSData *data;

	data = [defaults dataForKey:defaultName];
	if (data != nil) {
		*colorPtr = (NSColor *)[NSUnarchiver unarchiveObjectWithData:data];
		if (*colorPtr == nil) {
			*colorPtr = defColor;
		}
		[*colorPtr retain];
	} else {
		*colorPtr = defColor;
		[*colorPtr retain];
	}

}

// Read the UI elements from the Pref panel and set our internal instance vars
- (void)getPreferencePanelValues
{
	int i;
	
        enableSound = [self getCheckboxValue:soundCheckbox];
        speakLetters = [self getCheckboxValue:speakLettersCheckbox];
        speakShapes = [self getCheckboxValue:speakShapesCheckbox];
        speakImages = [self getCheckboxValue:speakImagesCheckbox];
        useCapitals = [self getCheckboxValue:capitalCheckbox];
	usePunctuation = [self getCheckboxValue:punctuationCheckbox];
        matchSounds = [self getCheckboxValue:matchSoundsCheckbox];
	onlyImages = [self getCheckboxValue:onlyImagesCheckbox];
	mapImages = [self getCheckboxValue:mapImagesCheckbox];
	quitKeysEnabled = [self getCheckboxValue:quitCommandCheckbox];
	useMouse = [self getCheckboxValue:drawingMouseCheckbox];
	matchLetters = [self getCheckboxValue:matchLettersCheckbox];
	speakColors = [self getCheckboxValue:speakColorsCheckbox];
	useRandomAlbum = [self getCheckboxValue:randomAlbumCheckbox];
	if ([albumPopup indexOfSelectedItem] > 0) {
		iPhotoAlbum = [albumPopup titleOfSelectedItem];		
	} else {
		iPhotoAlbum = @"";
	}
	shapeImagesRatio = [shapeImagesSlider floatValue];
	
	ABLog(@"shapeImagesRatio: %f", shapeImagesRatio);
	
	if ([clearItemsRadio selectedTag] == 0) {
		refreshCount = [clearItemsTextField intValue];
	} else {
		refreshCount = 0;
	}
	displayCount = [displayItemsTextField intValue];
	if (displayCount <= 0) {
		displayCount = 1;
	}
	[self setColorList:[[colorPopup selectedItem] title]];
	[self setMode:[modePopup indexOfSelectedItem]];
	drawingKind = [drawingKindRadio selectedTag];
	drawingColorKind = [drawingColorRadio selectedTag];
	if (drawingColor != nil) {
		[drawingColor release];
	}
	drawingColor = [drawingColorWell color];
	[drawingColor retain];
	[self setBackgroundColor:[backgroundColorWell color]];
	
	drawingWidth = [drawingLineWidthSlider intValue];
	for (i = 0; i < [windowList count]; i++) {
		[[windowList objectAtIndex:i] setAcceptsMouseMovedEvents:(!useMouse)];
	}
}

- (BOOL)getCheckboxValue:(id)checkbox
{
        if ([checkbox isEnabled] && ([checkbox state] == NSOnState)) {
                return YES;
        }
        return NO;
}

// ChangeFont is called each time the user selects a font in the Font Panel, not just
// when it is closed.
- (void) changeFont:(id)sender
{
	ABLog(@"In Changefont");
	newFont = [[NSFontManager sharedFontManager] convertFont:newFont];
	[fontNameField setStringValue:[NSString stringWithFormat:@"%@ %.1f",
		[newFont fontName], [newFont pointSize]]];


}

- (void)changeColor:(id)sender
{	
	ABLog(@"ChangeColor");
	if (newFixedColor != [sender color]) {
		if (newFixedColor) {
			[newFixedColor release];
		}
		newFixedColor = [[sender color] copy];
	}
	[self setFixedColorMenuItem:newFixedColor];
}

- (void)setFixedColorMenuItem:(NSColor *)color
{
	NSAttributedString	*coloredStr;
	
	coloredStr = [[NSAttributedString alloc] initWithString:@"Fixed color..." 
		attributes:[NSDictionary dictionaryWithObjectsAndKeys:
			color, NSForegroundColorAttributeName,
			[NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
			nil]];
		
	NSAssert(fixedColorItem != nil, @"fixedColorItem is nil!");
	[fixedColorItem setAttributedTitle:coloredStr];
	ABLog(@"just set fixed color menu item to %@", color);
}

- (void)loadImagesFromDirectory:(NSString *)dirName
{
	NSFileManager *fileManager;
	NSDirectoryEnumerator *dirEnum;
	NSString *file;
	NSImage *img;
	
	ABLog(@"loadImagesFromDirectory %@\n", dirName);
	
	if (imageList != nil) {
		[imageList removeAllObjects];
	} else {
		imageList = [[NSMutableArray alloc] initWithCapacity:10];
	}
        if (imageDict != nil) {
                [imageDict removeAllObjects];
        } else {
                imageDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        }
	fileManager = [NSFileManager defaultManager];
	dirEnum = [fileManager enumeratorAtPath:dirName];
	while (file = [dirEnum nextObject]) {
		NSString *ext = [file pathExtension];
		if (([ext caseInsensitiveCompare:@"png"] == NSOrderedSame) ||
		    ([ext caseInsensitiveCompare:@"jpg"] == NSOrderedSame) ||
		    ([ext caseInsensitiveCompare:@"tiff"] == NSOrderedSame) ||
		    ([ext caseInsensitiveCompare:@"gif"] == NSOrderedSame)) {
			img = [[NSImage alloc] initByReferencingFile:
				[dirName stringByAppendingPathComponent:file]];
			if (img != nil) {
				[img setCacheMode:NSImageCacheNever];
				[imageList addObject:img];
				if ([img setName:[file stringByDeletingPathExtension]]) {
					[imageDict setObject:img forKey:[img name]];				
				}
				[img release];
				//ABLog(@"Added image %@", file);
			} else {
				ABLog(@"initByReferencingFile file %@ returned nil", file);
			}
		} else {
			//ABLog(@"Skipping file %@", file);
		}
		
	}
	ABLog(@"Loaded %d images", [imageList count]);
	[self createMappedImageArray];
}

- (void)createMappedImageArray
{
	int i;
	int c;
	
	[imageList sortUsingFunction:compareImageNames context:nil];
	if ([imageList count] == 0) {
		return;
	}
	i = 0;
	for (c = 0; c < 256; c++) {
		mappedImageArray[c] = nil;
	}
	for (c = 'A'; c < 'Z'; c++, i++) {
		if (i >= [imageList count]) {
			i = 0;
		}
		mappedImageArray[c] = [imageList objectAtIndex:i];
		mappedImageArray[c+32] = [imageList objectAtIndex:i];
	}
	for (c = '0'; c < '9'; c++, i++) {
		if (i >= [imageList count]) {
			i = 0;
		}
		mappedImageArray[c] = [imageList objectAtIndex:i];
	}
	for (c = 0; c < 256; c++, i++) {
		if (i >= [imageList count]) {
			i = 0;
		}
		if (mappedImageArray[c] == nil) {
			mappedImageArray[c] = [imageList objectAtIndex:i];
		}
	}
	
}

/*
 * Load actual image files from a specificed iPhoto album.  The iPhoto album to be used
 * is specified by its index in the list of loaded iPhoto albums, loaded previously by
 * loadiPhotoAlbums.
 */
- (void)loadImagesFromAlbum:(int)albumIndex
{
	NSDictionary *album;
	NSArray *keyList;
	NSEnumerator *keyEnum;
	NSString *key;
	NSImage *img;

	NSAssert(albumList != nil, @"iPhoto albums have not been loaded");
	
	if (albumIndex < [albumList count]) {
		album = [albumList objectAtIndex:albumIndex];
		keyList = [album objectForKey:@"KeyList"];
		keyEnum = [keyList objectEnumerator];
	} else {
		return;
	}
	
	if (imageList != nil) {
		[imageList removeAllObjects];
	} else {
		imageList = [[NSMutableArray alloc] initWithCapacity:10];
	}
        if (imageDict != nil) {
                [imageDict removeAllObjects];
        } else {
                imageDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        }
	
	while ((key = [keyEnum nextObject])) {
		NSDictionary *image = [iImageList objectForKey:key];
		NSString *path = [image objectForKey:@"ImagePath"];
		img = [[NSImage alloc] initByReferencingFile:path];
		if (img != nil) {
			//[img setCacheMode:NSImageCacheNever];
			[imageList addObject:img];
			if ([img setName:[image objectForKey:@"Caption"]]) {
				[imageDict setObject:img forKey:[img name]];
			}
			[img release];
		}		
	}
	ABLog(@"Loaded %d images", [imageList count]);

	[self createMappedImageArray];
}

/* Experiment with loading in iPhoto albums.  This routine uses the global iPhoto preferences file
 * to locate the current root directory of iPhoto.  The AlbumData file is loaded and parsed to get
 * a list of all photo albums.  If this routine is successful, the instance vars albumList and
 * iImageList will be non-nil and populated with the list of Albums and the list of information
 * about all images in those Albums, respectively.
 */
- (void)loadiPhotoAlbums
{
	NSString *home;
	NSString *prefsFile;
	NSDictionary *iPhotoPrefs;
	NSString *rootDir;
	NSString *albumFile;
	NSDictionary *albumData;
	NSEnumerator *albumEnum;
	NSDictionary *albumInfo;
	int i = 0;

	albumList = nil;
	iImageList = nil;
	albumNameList = nil;
	
	home = NSHomeDirectory();
	ABLog(@"home = %@", home);
	prefsFile = [home stringByAppendingString:
		@"/Library/Preferences/com.apple.iPhoto.plist"];
	ABLog(@"prefsFile = %@", prefsFile);
	iPhotoPrefs = [NSDictionary dictionaryWithContentsOfFile:prefsFile];
	if (iPhotoPrefs == nil) {
		ABLog(@"failed to load iPhoto albums - no com.apple.iPhoto.plist file");
		return;
	}
	rootDir = [iPhotoPrefs objectForKey:@"RootDirectory"];
	if (rootDir == nil) {
		ABLog(@"Failed to locate RootDirectory key");
		return;
	}
	ABLog(@"rootDir = %@", rootDir);
	albumFile = [[rootDir stringByExpandingTildeInPath] stringByAppendingString:@"/AlbumData.xml"];
	ABLog(@"About to open album file %@", albumFile);
	albumData = [NSDictionary dictionaryWithContentsOfFile:albumFile];
	if (albumData == nil) {
		ABLog(@"failed to load iPhoto albums - no AlbumData.xml file %@", albumFile);
		return;
	}
		
	albumList = [albumData objectForKey:@"List of Albums"];
	if (albumList == nil) {
		ABLog(@"failed to get List of Albums key value");
		return;
	}
	[albumList retain];
	
	iImageList = [albumData objectForKey:@"Master Image List"];
	if (iImageList == nil) {
		ABLog(@"failed to get Master Image List key value");
		return;
	}
	[iImageList retain];
	
	//NSLog(@"data = %@", [albumList description]);
	ABLog(@"there are %d albums", [albumList count]);
	albumEnum = [albumList objectEnumerator];
	albumNameList = [NSMutableArray arrayWithCapacity:[albumList count]+1];
	[albumNameList retain];
	
	//[albumPopup addItemWithTitle:@"No album"];
	[albumNameList addObject:@"No album"];
	while ((albumInfo = [albumEnum nextObject])) {
		NSString *name =  [albumInfo objectForKey:@"AlbumName"];
		ABLog(@"%d: %@", i++, name);
		// Problem here!! If you add an album with the same name as one that exists, 
		// it will get removed from the list where it was, and added to the end, making
		// the popup button not match the albumList.  The fix is to append spaces to the
		// end of the album  name, which will basically be invisible to the user, but will
		// fix the popuplist problem.
		while ([albumNameList indexOfObject:name] != NSNotFound) {
			name = [name stringByAppendingString:@" "];
		}
		//[albumPopup addItemWithTitle:name];
		[albumNameList addObject:name];
	}	
}

- (void)loadSoundsFromDirectory:(NSString *)dirName
{
	NSFileManager *fileManager;
	NSDirectoryEnumerator *dirEnum;
	NSString *file;
	NSSound *snd;
	
	ABLog(@"loadSoundsFromDirectory %@\n", dirName);
	
	if (soundList != nil) {
		[soundList removeAllObjects];
	} else {
		soundList = [[NSMutableArray alloc] initWithCapacity:10];
	}
        if (soundDict != nil) {
                [soundDict removeAllObjects];
        } else {
                soundDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        }
	fileManager = [NSFileManager defaultManager];
	dirEnum = [fileManager enumeratorAtPath:dirName];
	while (file = [dirEnum nextObject]) {
		NSString *ext = [file pathExtension];
		if (([ext caseInsensitiveCompare:@"aiff"] == NSOrderedSame) ||
		    ([ext caseInsensitiveCompare:@"aif"] == NSOrderedSame) ||
		    ([ext caseInsensitiveCompare:@"caf"] == NSOrderedSame) ||
		    ([ext caseInsensitiveCompare:@"wav"] == NSOrderedSame)) {
			snd = [[NSSound alloc] initWithContentsOfFile:[dirName stringByAppendingPathComponent:file] byReference:YES];
			if (snd != nil) {
				[soundList addObject:snd];
                                if ([snd setName:[[file lastPathComponent] stringByDeletingPathExtension]]) {
					// If this is the first sound with the name, load it into the sound dictionary
					[soundDict setObject:snd forKey:[snd name]];
				}
				[snd release];
				//ABLog(@"Added sound %@", file);
			} else {
				ABLog(@"initWithContentsOfFile file %@ returned nil", file);
			}
		} else {
			//ABLog(@"Skipping file %@", file);
		}
		
	}
	ABLog(@"Loaded %d sounds", [soundList count]);
	ABLog(@"soundDict = %@", [soundDict description]);
}

- (void) loadDefaultSounds
{
	NSArray *paths;
	int numPaths;
	int i;
	NSString *libPath;
	NSArray *soundsPathList;
	NSString *soundPath;
	NSEnumerator *e;
	
	defaultSoundList = [[NSMutableArray alloc] init];
	
	paths = NSSearchPathForDirectoriesInDomains(NSAllLibrariesDirectory, NSAllDomainsMask&(~NSNetworkDomainMask), YES);
	numPaths = [paths count];
	
	for (i = 0; i < numPaths; i++) {
		//ABLog(@"path %d:%@", i, [paths objectAtIndex:i]);
		libPath = [[paths objectAtIndex:i] stringByAppendingPathComponent:@"Sounds"];
		soundsPathList = [NSBundle pathsForResourcesOfType: @"aiff" inDirectory: libPath];
		
		e = [soundsPathList objectEnumerator];
		while ( soundPath = (NSString *) [e nextObject] ) {
			NSSound *snd;
			//ABLog(@"adding sound %@", soundPath);
			//ABLog(@"name %@", [[soundPath lastPathComponent] stringByDeletingPathExtension]);
			snd = [NSSound soundNamed:[[soundPath lastPathComponent] stringByDeletingPathExtension]];
			//ABLog(@"snd = %@", snd);
			//[snd retain];
			[defaultSoundList addObject:snd ];
		}
	}
	//ABLog(@"defaultSoundList count = %d", [defaultSoundList count]);
}

#pragma mark ACCESSOR METHODS

- (int)numShapesToDraw
{
	return refreshCount;
}

- (BOOL)soundsEnabled
{
	return enableSound;
}

- (NSColor *)backgroundColor 
{
	return [[backgroundColor retain] autorelease];
}

- (void)setBackgroundColor:(NSColor *)aBackgroundColor
{
	if (backgroundColor != aBackgroundColor) {
		[backgroundColor release];
		backgroundColor = [aBackgroundColor copy];
	}
}

- (int) numLoadedImages
{
	if (imageList != nil) {
		return [imageList count];
	}
	return 0;
}

- (ColorManager *)colorManager
{
	return colorManager;
}

- (int)numItemsDrawn
{
    return numItemsDrawn;
}

- (void)itemDrawn
{
    ++numItemsDrawn;
}

- (int)refreshCount
{
        return refreshCount;
}

- (void)setRefreshCount:(int)aRefreshCount
{
        refreshCount = aRefreshCount;
}

- (int)displayCount
{
	return displayCount;
}

- (void)setDisplayCount:(int)aDisplayCount
{
	displayCount = aDisplayCount;
}

- (BOOL)enableSound
{
        return enableSound;
}

- (void)setEnableSound:(BOOL)flag
{
        enableSound = flag;
}

- (BOOL)speakLetters
{
        return speakLetters;
}

- (void)setSpeakLetters:(BOOL)flag
{
        speakLetters = flag;
}

- (BOOL)speakShapes
{
        return speakShapes;
}

- (void)setSpeakShapes:(BOOL)flag
{
        speakShapes = flag;
}

- (BOOL)speakImages
{
        return speakImages;
}

- (void)setSpeakImages:(BOOL)flag
{
        speakImages = flag;
}

- (BOOL)matchSounds
{
        return matchSounds;
}

- (void)setMatchSounds:(BOOL)flag
{
        matchSounds = flag;
}

- (BOOL)mapImages
{
        return mapImages;
}

- (void)setMapImages:(BOOL)flag
{
        mapImages = flag;
}

- (BOOL)onlyImages
{
        return onlyImages;
}

- (void)setOnlyImages:(BOOL)flag
{
        onlyImages = flag;
}

- (float)shapeImagesRatio
{
        return shapeImagesRatio;
}

- (void)setShapeImagesRatio:(float)aShapeImagesRatio
{
        shapeImagesRatio = aShapeImagesRatio;
}

- (NSString *)imageFolderPath
{
        return [[imageFolderPath retain] autorelease];
}

- (void)setImageFolderPath:(NSString *)anImageFolderPath
{
        if (imageFolderPath != anImageFolderPath) {
                [anImageFolderPath retain];
                [imageFolderPath release];
                imageFolderPath = anImageFolderPath;
        }
}

- (NSString *)fontName
{
        return [[fontName retain] autorelease];
}

- (void)setFontName:(NSString *)aFontName
{
        if (fontName != aFontName) {
                [aFontName retain];
                [fontName release];
                fontName = aFontName;
        }
}

- (float)fontSize 
{
        return fontSize;
}

- (void)setFontSize:(float)aFontSize
{
        fontSize = aFontSize;
}

- (NSFont *)letterFont
{
        return [[letterFont retain] autorelease];
}

- (NSFont *)bigFont
{
        return [[bigFont retain] autorelease];
}

- (void)setBigFont:(NSFont *)aBigFont
{
	if (bigFont != aBigFont) {
		[bigFont retain];
		[bigFont release];
		bigFont = aBigFont;
	}
}

- (void)setLetterFont:(NSFont *)aLetterFont
{
        if (letterFont != aLetterFont) {
                [aLetterFont retain];
                [letterFont release];
                letterFont = aLetterFont;
        }
}

- (BOOL)defaultFont
{
        return defaultFont;
}

- (void)setDefaultFont:(BOOL)flag
{
        defaultFont = flag;
}

- (BOOL)useCapitals
{
        return useCapitals;
}

- (void)setUseCapitals:(BOOL)flag 
{
        useCapitals = flag;
}

- (BOOL)usePunctuation
{
	return usePunctuation;
}

- (void)setUsePunctuation:(BOOL)flag
{
	usePunctuation = flag;
}

- (id)prefsPanel
{
	return prefsPanel;
}

- (NSString *)soundFolderPath
{
        return [[soundFolderPath retain] autorelease];
}

- (void)setSoundFolderPath:(NSString *)aSoundFolderPath
{
        if (soundFolderPath != aSoundFolderPath) {
                [aSoundFolderPath retain];
                [soundFolderPath release];
                soundFolderPath = aSoundFolderPath;
        }
}

- (NSString *)colorList
{
        return [[colorList retain] autorelease];
}

- (void)setColorList:(NSString *)aColorList
{
        if (colorList != aColorList) {
                [aColorList retain];
                [colorList release];
                colorList = aColorList;
        }
}

- (int)mode
{
	return mode;
}

- (void)setMode:(int)newMode
{
	if (mode != newMode) {
		if (mode == MODE_TYPING) {
			[mainView clearScreen];
		}
		
		if (newMode == MODE_ALPHABET) {
			currentAlphabetChar = 'a';
		}
		if ((newMode == MODE_ALPHABET) || (newMode == MODE_LETTER)) {
			// clear screen(s)
			[mainView clearScreen];
		}
		if (newMode == MODE_TYPING) {
			// clear screen
			[mainView clearScreen];
		}
		mode = newMode;
		if (mainView != nil) {
			[mainView switchToMode:mode];
		}
	}
}

- (int)quitKeysEnabled
{
	return quitKeysEnabled;
}

- (void)setQuitKeysEnabled:(BOOL)flag
{
	quitKeysEnabled = flag;
}

- (unsigned int)myModifierFlags
{
	return myModifierFlags;
}

- (void)setMyModifierFlags:(unsigned int)flags
{
	myModifierFlags = flags;
}

- (int)drawingKind
{
	return drawingKind;
}

- (NSColor *)drawingColor
{
	return drawingColor;
}

- (int)drawingColorKind
{
	return drawingColorKind;
}

- (int)drawingWidth
{
	return drawingWidth;
}

- (BOOL)speakColors
{
	return speakColors;
}

- (BOOL)matchLetters
{
	return matchLetters;
}

- (BOOL)useMouse
{
	return useMouse;
}

@end
