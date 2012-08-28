//
//  WTAppDelegate.m
//  WrapTunes
//
//  Created by Greg V on 8/25/12.
//  Copyright (c) 2012 { float:both }. All rights reserved.
//

#import "WTAppDelegate.h"

@implementation WTAppDelegate

- (void)playpause { [scripter evaluateWebScript:playpauseScript]; }
- (void)next { [scripter evaluateWebScript:nextScript]; }
- (void)prev { [scripter evaluateWebScript:prevScript]; }

- (void)loadConfig {
    sites = [[NSArray alloc] initWithContentsOfFile:plistpath];
    [sites enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSMenuItem *item = [NSMenuItem new];
        [item setTitle:[obj valueForKey:@"name"]];
        [item setTarget:self];
        [item setAction:@selector(switchSiteAction:)];
        [item setRepresentedObject:obj];
        [self.sitesmenu addItem:item];
    }];
    
}

- (void)switchSite:(NSDictionary *)site {
    playpauseScript = [site valueForKey:@"playpause"];
    nextScript = [site valueForKey:@"next"];
    prevScript = [site valueForKey:@"prev"];
    [self.webview setMainFrameURL:[site valueForKey:@"url"]];
}


- (void)copyConfig {
    [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"DefaultSiteList" ofType:@"plist"] toPath:plistpath error:NULL];
}

/////// Actions

- (IBAction)switchSiteAction:(id)sender {
    [[self.sitesmenu itemArray] enumerateObjectsUsingBlock:^(NSMenuItem *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:NSOffState];
    }];
    [sender setState:NSOnState];
    NSDictionary *site = [sender representedObject];
    [self switchSite:site];
}

- (IBAction)editConfig:(id)sender {
    [[NSWorkspace sharedWorkspace] openFile:plistpath];
}

- (IBAction)reloadConfig:(id)sender {
    [sites enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [self.sitesmenu removeItem:[self.sitesmenu itemWithTitle:[obj valueForKey:@"name"]]];
    }];
    [self loadConfig];
}

- (IBAction)restoreConfig:(id)sender {
    NSAlert *confirmation = [NSAlert new];
    [confirmation setMessageText:@"Are you sure you want to restore the default list?"];
    [confirmation setAlertStyle:NSWarningAlertStyle];
    [confirmation addButtonWithTitle:@"OK"];
    [confirmation addButtonWithTitle:@"Cancel"];
    if ([confirmation runModal] == 1000) {
        [self copyConfig];
        NSAlert *success = [NSAlert new];
        [success setMessageText:@"Done!"];
        [success addButtonWithTitle:@"OK"];
        [success runModal];
    }
}

- (IBAction)openWindow:(id)sender {
    [self.window makeKeyAndOrderFront:self];
}

/////// Implementation of protocols

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    plistpath = [@"~/.wraptunes.plist" stringByExpandingTildeInPath];
    fm = [NSFileManager new];
    if (![fm fileExistsAtPath:plistpath]) {
        [self copyConfig];
    }
    
    scripter = [self.webview windowScriptObject];
    playpauseScript = @"";
    nextScript = @"";
    prevScript = @"";
    [self loadConfig];
    [self switchSite:[sites objectAtIndex:0]];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.window makeKeyAndOrderFront:self];
    return NO;
}

@end
