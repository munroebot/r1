#import "NSUserDefaults+myColorSupport.h"


@implementation NSUserDefaults(myColorSupport)

- (void)my_setColor:(NSColor *)aColor forKey:(NSString *)aKey
{
	NSData *theData=[NSArchiver archivedDataWithRootObject:aColor];
	[self setObject:theData forKey:aKey];
}


- (NSColor *)my_colorForKey:(NSString *)aKey
{
	NSColor *theColor=nil;
	NSData *theData=[self dataForKey:aKey];

	if (theData != nil) {
		theColor=(NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
	}
	return theColor;
}

@end