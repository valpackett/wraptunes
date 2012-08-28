//
//  WTAppDelegate.m
//  WrapTunes
//
//  Created by Greg V on 8/25/12.
//  Copyright (c) 2012 { float:both }. All rights reserved.
//

#import "WTAppDelegate.h"

@implementation WTAppDelegate

- (void)playpause
{
    [scripter evaluateWebScript:playpauseScript];
}

- (void)next
{
    [scripter evaluateWebScript:nextScript];
}

- (void)prev
{
    [scripter evaluateWebScript:prevScript];
}

- (void)loadConfig
{
    NSArray *sites = [[NSArray alloc] initWithContentsOfFile:plistpath];
    [sites enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSMenuItem *item = [NSMenuItem new];
        [item setTitle:[obj valueForKey:@"name"]];
        [item setTarget:self];
        [item setAction:@selector(switchSiteAction:)];
        [item setRepresentedObject:obj];
        [self.sitesmenu addItem:item];
    }];
    [self switchSite:[sites objectAtIndex:0]];
}

- (IBAction)switchSiteAction:(id)sender {
    [[self.sitesmenu itemArray] enumerateObjectsUsingBlock:^(NSMenuItem *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:NSOffState];
    }];
    [sender setState:NSOnState];
    NSDictionary *site = [sender representedObject];
    [self switchSite:site];
}

- (void)switchSite:(NSDictionary *)site
{
    playpauseScript = [site valueForKey:@"playpause"];
    nextScript = [site valueForKey:@"next"];
    prevScript = [site valueForKey:@"prev"];
    [self.webview setMainFrameURL:[site valueForKey:@"url"]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    plistpath = [@"~/.wraptunes.plist" stringByExpandingTildeInPath];
    NSFileManager *fm = [NSFileManager new];
    if (![fm fileExistsAtPath:plistpath]) {
        [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"DefaultSiteList" ofType:@"plist"] toPath:plistpath error:NULL];
    }
    
    scripter = [self.webview windowScriptObject];
    playpauseScript = @"";
    nextScript = @"";
    prevScript = @"";
    [self loadConfig];
}

- (IBAction)openWindow:(id)sender {
    [self.window makeKeyAndOrderFront:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return NO;
}

@end
