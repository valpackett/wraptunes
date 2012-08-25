//
//  WTApplication.m
//  WrapTunes
//
//  Created by Greg V on 8/25/12.
//  Copyright (c) 2012 { float:both }. All rights reserved.
//

#import "WTApplication.h"


@implementation WTApplication

- (void)sendEvent:(NSEvent*)event
{
	if ([event type] == NSSystemDefined && [event subtype] == 8) {
		int keyCode = (([event data1] & 0xFFFF0000) >> 16);
		int keyFlags = ([event data1] & 0x0000FFFF);
		int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
		int keyRepeat = (keyFlags & 0x1);
		
		[self mediaKeyEvent:keyCode state:keyState repeat:keyRepeat];
	}
    
	[super sendEvent:event];
}

- (void)mediaKeyEvent:(int)key state:(BOOL)state repeat:(BOOL)repeat
{
    if (state == 0) {
        WTAppDelegate *delegate = [self delegate];
        switch (key) {
            case NX_KEYTYPE_PLAY:
                [delegate playpause];
                break;
            case NX_KEYTYPE_FAST:
                [delegate next];
                break;
            case NX_KEYTYPE_REWIND:
                [delegate prev];
                break;
        }
    }
}
@end
