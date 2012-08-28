//
//  WTAppDelegate.h
//  WrapTunes
//
//  Created by Greg V on 8/25/12.
//  Copyright (c) 2012 { float:both }. No rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface WTAppDelegate : NSObject <NSApplicationDelegate> {
    WebScriptObject *scripter;
    NSString *playpauseScript;
    NSString *nextScript;
    NSString *prevScript;
    NSString *plistpath;
    NSArray *sites;
    NSFileManager *fm;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webview;
@property (assign) IBOutlet NSMenuItem *openitem;
@property (assign) IBOutlet NSMenu *sitesmenu;

- (void)playpause;
- (void)next;
- (void)prev;

@end
