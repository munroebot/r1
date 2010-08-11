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
#import <ApplicationServices/ApplicationServices.h>
#import <PoundWindow.h>
#import <PoundView.h>
#import <Quicktime/Quicktime.h>
#import "ColorManager.h"

#define MODE_RANDOM	0
#define MODE_LETTER	1
#define MODE_ALPHABET	2
#define MODE_TYPING	3
#define MODE_LETTERS	4
#define MODE_SHAPES	5
#define MODE_WORDS	6

#define DRAW_STARS	0
#define DRAW_LINES	1
#define DRAW_SQUARES	2
#define DRAW_CIRCLES	3
#define DRAW_DUCKS	4
#define DRAW_TRUCKS	5

#define DRAWCOLOR_FIXED		0
#define DRAWCOLOR_RANDOM	1
#define DRAWCOLOR_RAINBOW	2

@class PoundView;

@interface Controller : NSObject <NSWindowDelegate>
{
	// Outlets

	IBOutlet id albumPopup;
	IBOutlet id backgroundColorWell;
        IBOutlet id capitalCheckbox;
        IBOutlet id clearImageFolderButton;
        IBOutlet id clearItemsRadio;
        IBOutlet id clearItemsTextField;
        IBOutlet id colorManager;
        IBOutlet id colorPopup;
	IBOutlet id displayItemsTextField;
	IBOutlet id drawingKindRadio;
	IBOutlet id drawingColorRadio;
	IBOutlet id drawingColorWell;
	IBOutlet id drawingLineWidthLabel;
	IBOutlet id drawingLineWidthSlider;
	IBOutlet id drawingMouseCheckbox;
	IBOutlet id fixedColorItem;
        IBOutlet id fontNameField;
	IBOutlet id imageFolderButton;
        IBOutlet id imageFolderField;
        IBOutlet id mapImagesCheckbox;
	IBOutlet id matchLettersCheckbox;
        IBOutlet id matchSoundsCheckbox;
	IBOutlet id modePopup;
        IBOutlet id onlyImagesCheckbox;
        IBOutlet id prefsPanel;
	IBOutlet id punctuationCheckbox;
	IBOutlet id quitCommandCheckbox;
	IBOutlet id randomAlbumCheckbox;
        IBOutlet id shapeImagesSlider;
        IBOutlet id soundCheckbox;
        IBOutlet id soundsFolderField;
	IBOutlet id speakAllKeysCheckbox;
	IBOutlet id speakColorsCheckbox;
        IBOutlet id speakImagesCheckbox;
        IBOutlet id speakLettersCheckbox;
        IBOutlet id speakShapesCheckbox;
	IBOutlet id versionString;
        
	// Other instance variables
	PoundWindow *mainWindow;
	PoundView *mainView;
	int origWindowLevel;
	int shieldWindowLevel;
	SystemUIMode uiMode;
	SystemUIOptions uiOpts;
	NSMutableArray *imageList;
	NSMutableArray *soundList;
	NSMutableArray *defaultSoundList;
	NSMutableArray *windowList;
	NSMutableArray *viewList;
        int numItemsDrawn;
        NSMutableDictionary *imageDict;
        NSMutableDictionary *soundDict;
	NSImage **mappedImageArray;
	BOOL soundIsPlaying;
	NSSound *playingSound;
	int currentAlphabetChar;
	unsigned int myModifierFlags;
	NSDictionary *iImageList;
	NSArray *albumList;
	NSMutableArray *albumNameList;
	NSSpeechSynthesizer *speechSynth;
	NSDictionary *keyNames;

	char *quitChars;
	char *prefChars;
	int currentQuitChar;
	int currentPrefChar;
	BOOL quitTimerRunning;
	NSTimer *quitTimer;
	NSTimer *activityTimer;
	
	// The following fields can be set by user preferences
	int refreshCount;
	int displayCount;
	BOOL enableSound;
	BOOL speakLetters;
	BOOL speakShapes;
        BOOL speakImages;
        BOOL matchSounds;
        BOOL mapImages;
        BOOL onlyImages;
	BOOL useRandomAlbum;
        float shapeImagesRatio;
	NSString *imageFolderPath;
	NSString *fontName;
	float fontSize;
	NSFont *letterFont;
	NSFont *bigFont;
	BOOL defaultFont;
	BOOL useCapitals;
	BOOL usePunctuation;
	NSString *soundFolderPath;
	NSString *colorList;
	int mode;
	BOOL quitKeysEnabled;
	int drawingKind;
	int drawingColorKind;
	NSColor *drawingColor;
	NSColor *backgroundColor;
	NSColor *textColor;
	int drawingWidth;
	BOOL useMouse;
	BOOL matchLetters;
	BOOL speakColors;
	NSString *iPhotoAlbum;
	
	// Temporary fields used when setting preferences
	NSString *newImageFolderPath;
	NSFont *newFont;
	NSString *newSoundFolderPath;
	NSColor *newFixedColor;
	BOOL showingPrefs;
	int oldAlbumIndex;
}

// Actions

- (IBAction)albumChosen:(id)sender;
- (IBAction)clearImageFolder:(id)sender;
- (IBAction)clearScreen:(id)sender;
- (IBAction)clearSoundFolder:(id)sender;
- (IBAction)preferencesCancel:(id)sender;
- (IBAction)preferencesDone:(id)sender;
- (IBAction)resetFont:(id)sender;
- (IBAction)resetPreferences:(id)sender;
- (IBAction)setClearScreen:(id)sender;
- (IBAction)setImageFolder:(id)sender;
- (IBAction)displayFontPanel:(id)sender;
- (IBAction)setSound:(id)sender;
- (IBAction)setSoundFolder:(id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)showQuitInfo:(id)sender;
- (IBAction)clickedOnlyImages:(id)sender;
- (IBAction)terminate:(id)sender;
- (IBAction)updateLineWidthLabel:(id)sender;
- (IBAction)setFixedColor:(id)sender;

// Instance variable accessor methods
- (int)refreshCount;
- (void)setRefreshCount:(int)aRefreshCount;

- (int)displayCount;
- (void)setDisplayCount:(int)aDisplayCount;

- (BOOL)enableSound;
- (void)setEnableSound:(BOOL)flag;

- (BOOL)speakLetters;
- (void)setSpeakLetters:(BOOL)flag;

- (BOOL)speakShapes;
- (void)setSpeakShapes:(BOOL)flag;

- (BOOL)speakImages;
- (void)setSpeakImages:(BOOL)flag;

- (BOOL)matchSounds;
- (void)setMatchSounds:(BOOL)flag;

- (BOOL)mapImages;
- (void)setMapImages:(BOOL)flag;

- (BOOL)onlyImages;
- (void)setOnlyImages:(BOOL)flag;

- (float)shapeImagesRatio;
- (void)setShapeImagesRatio:(float)aShapeImagesRatio;

- (NSString *)imageFolderPath;
- (void)setImageFolderPath:(NSString *)anImageFolderPath;

- (NSString *)fontName;
- (void)setFontName:(NSString *)aFontName;

- (float)fontSize;
- (void)setFontSize:(float)aFontSize;

- (NSFont *)letterFont;
- (void)setLetterFont:(NSFont *)aLetterFont;

- (NSFont *)bigFont;
- (void)setBigFont:(NSFont *)aBigFont;

- (BOOL)defaultFont;
- (void)setDefaultFont:(BOOL)flag;

- (BOOL)useCapitals;
- (void)setUseCapitals:(BOOL)flag;

- (BOOL)usePunctuation;
- (void)setUsePunctuation:(BOOL)flag;


- (NSString *)soundFolderPath;
- (void)setSoundFolderPath:(NSString *)aSoundFolderPath;

- (NSString *)colorList;
- (void)setColorList:(NSString *)aColorList;

- (int)mode;
- (void)setMode:(int)mode;

- (int)quitKeysEnabled;
- (void)setQuitKeysEnabled:(BOOL)flag;

- (NSColor *)backgroundColor;
- (void)setBackgroundColor:(NSColor *)aBackgroundColor;

- (int)drawingKind;
- (NSColor *)drawingColor;
- (int)drawingColorKind;
- (int)drawingWidth;
- (BOOL)speakColors;
- (BOOL)matchLetters;
- (BOOL)useMouse;

// Other instance methods

- (int)numShapesToDraw;
- (BOOL)soundsEnabled;
- (int)numItemsDrawn;
- (void)itemDrawn;
- (BOOL)needsRefresh;
- (int)currentAlphabetChar;
- (id)prefsPanel;
- (unsigned int)myModifierFlags;
- (void)setMyModifierFlags:(unsigned int)flags;
- (void)endFullScreen;
- (void)beginFullScreen;
- (void)loadiPhotoAlbums;
- (void)speakString:(NSString *)str;
- (void)setFixedColorMenuItem:(NSColor *)color;

+ (Controller *)createController:(PoundView *)theView;
- (void)doInitialization;
#ifdef ALPHABABY_SCREENSAVER
- (void)setupSaverWindow:(PoundView *)theView;
#endif
- (void)createWindowsAndViews;
- (void)loadImagesFromDirectory:(NSString *)dirName;
- (void)loadSoundsFromDirectory:(NSString *)dirName;
- (void)loadImagesFromAlbum:(int)albumIndex;
- (void)loadDefaultSounds;
- (void)startActivityThread;
- (void)insertRandomEvent:(NSTimer *)timer;
- (void)createMappedImageArray;

- (int) numLoadedImages;
- (NSImage *)getMappedImageForKey:(int)key;
- (NSImage *)getRandomImage;
- (NSSound *)getRandomSound;
- (PoundView *)getRandomView;
- (NSSound *)getSoundNamed:(NSString *)name;
- (void)playSound:(NSSound *)snd;

+ (NSUserDefaults *)getDefaults;
- (void)saveUserPreferences;
- (void)initUserPreferences;
- (void)setPreferencePanelValues;
- (void)getPreferencePanelValues;
- (void)readColorFromDefaults:(NSString *)defaultName toColor:(NSColor **)colorPtr
	withDefault:(NSColor *)defColor;
	
- (BOOL)getCheckboxValue:(id)checkbox;

- (BOOL)checkQuitCharacter:(int)c;
- (void)quitTimerExpired:(NSTimer *)timer;

// Accessors for preference items
- (int) refreshCount;
- (BOOL) enableSound;
- (NSString *)imageFolderPath;
- (void)setImageFolderPath:(NSString *)path;
- (NSString *)fontName;
- (void)setFontName:(NSString *)name;
- (float) fontSize;
- (void) setFontSize:(float)points;
- (BOOL) defaultFont;
- (ColorManager *)colorManager;
- (BOOL)useCapitals;

@end
