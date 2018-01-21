//
//  AppDelegate.m
//  shapeview
//
//  Created by Brice Rosenzweig on 29/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "AppDelegate.h"
#import "SVPreferenceViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic,retain) NSWindow * prefWindow;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [SVPreferenceViewController setDefaultPreferences];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)newDocument:(id)sender{
    [self.window makeKeyAndOrderFront:self];
}
- (IBAction)showPreference:(id)sender {
    if (!self.prefWindow) {
        SVPreferenceViewController * pc = [[SVPreferenceViewController alloc] initWithNibName:@"SVPreferenceViewController" bundle:nil ];
        self.prefWindow = [NSWindow windowWithContentViewController:pc];
        self.prefWindow.title = @"Preferences";
    }
    [self.prefWindow makeKeyAndOrderFront:self];
}


@end
