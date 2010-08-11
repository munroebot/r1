//
//  ABApplication.m
//  AlphaBaby
//
//  Created by Laura Dickey on 6/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ABApplication.h"
#import "ABDebug.h"

@implementation ABApplication

- (void)sendEvent:(NSEvent *)theEvent { 
	//ABLog(@"sendEvent: of ABApplication %@", theEvent);
	if ([theEvent type] == NSKeyUp) {
		ABLog(@"#keyup: keycode %d, characters %@", [theEvent keyCode], [theEvent characters]);
	} else if ([theEvent type] == NSFlagsChanged) {
		ABLog(@"#flags: keycode %d", [theEvent keyCode]);
	} else if ([theEvent type] == NSSystemDefined) {
		ABLog(@"#sysde: subtype %x, data1 = %x, data2 = %x", [theEvent subtype], [theEvent data1], [theEvent data2]);
		// subtype 8 appears to correspond to volume and brightness key events.
		// just return so they are not passed on to the system
	} else if ([theEvent type] == NSAppKitDefined) {
		ABLog(@"#appkt: subtype %x, data1 = %x, data2 = %x", [theEvent subtype], [theEvent data1], [theEvent data2]);
	}
	[super sendEvent:theEvent];
} 

@end
