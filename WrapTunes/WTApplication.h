//
//  WTApplication.h
//  WrapTunes
//
//  Created by Greg V on 8/25/12.
//  Copyright (c) 2012 { float:both }. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WTAppDelegate.h"
#import <IOKit/hidsystem/ev_keymap.h>

@interface WTApplication : NSApplication

- (void)mediaKeyEvent:(int)key state:(BOOL)state repeat:(BOOL)repeat;

@end
