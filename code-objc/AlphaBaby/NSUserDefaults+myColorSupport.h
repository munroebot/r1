#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface NSUserDefaults(myColorSupport)
- (void)my_setColor:(NSColor *)aColor forKey:(NSString *)aKey;
- (NSColor *)my_colorForKey:(NSString *)aKey;
@end