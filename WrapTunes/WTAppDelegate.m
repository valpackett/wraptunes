//
//  WTAppDelegate.m
//  WrapTunes
//
//  Created by Greg V on 8/25/12.
//  Copyright (c) 2012 { float:both }. No rights reserved.
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
        [item setAction:@selector(switchSite:)];
        [item setRepresentedObject:obj];
        [self.sitesmenu addItem:item];
    }];
}

- (void)setSite:(NSDictionary *)site {
    playpauseScript = [site valueForKey:@"playpause"];
    nextScript = [site valueForKey:@"next"];
    prevScript = [site valueForKey:@"prev"];
    [self.webview setMainFrameURL:[site valueForKey:@"url"]];
}

- (void)copyConfig {
    [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"DefaultSiteList" ofType:@"plist"] toPath:plistpath error:NULL];
}

/////// Actions

- (IBAction)switchSite:(id)sender {
    [sites enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [[self.sitesmenu itemWithTitle:[obj valueForKey:@"name"]] setState:NSOffState];
    }];
    [sender setState:NSOnState];
    [self setSite:[sender representedObject]];
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
    NSAlert *confirmation = [NSAlert alertWithMessageText:@"Are you sure you want to restore the default list?" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@""];
    [confirmation setAlertStyle:NSWarningAlertStyle];
    if ([confirmation runModal] == NSAlertDefaultReturn) {
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

- (IBAction)refreshWeb:(id)sender {
    [self.webview reload:@""];
}

- (IBAction)changeURL:(id)sender {
    NSAlert *alert = [NSAlert alertWithMessageText:@"Change the URL?" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@""];
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 24)];
    [input setStringValue:[self.webview mainFrameURL]];
    [alert setAccessoryView:input];
    if ([alert runModal] == NSAlertDefaultReturn) {
        [input validateEditing];
        [self.webview setMainFrameURL:[input stringValue]];
    }
}

/////// Implementation of protocols

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    scripter = [self.webview windowScriptObject];
    plistpath = [@"~/.wraptunes.plist" stringByExpandingTildeInPath];
    fm = [NSFileManager new];
    if (![fm fileExistsAtPath:plistpath]) {
        [self copyConfig];
    }
    [self loadConfig];
    [self setSite:[sites objectAtIndex:0]];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.window makeKeyAndOrderFront:self];
    return NO;
}

@end
