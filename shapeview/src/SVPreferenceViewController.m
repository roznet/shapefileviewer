//
//  SVPreferenceViewController.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 03/04/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "SVPreferenceViewController.h"
#import "RZUtilsOSX/RZUtilsOSX.h"
#import "RZUtilsUniversal/RZUtilsUniversal.h"

NSString * SVPrefShapeColor = @"SVPrefShapeColor";
NSString * SVPrefShapeTransparency = @"SVPrefShapeTransparency";
NSString * SVPrefDrawLine = @"SVPrefDrawLine";
NSString * SVPrefLineColor = @"SVPrefLineColor";
NSString * SVPrefLineWidth = @"SVPrefLineWidth";
NSString * SVNotifyPreferenceChanged = @"SVNotifyPreferenceChanged";

@interface SVPreferenceViewController ()
@property (weak) IBOutlet NSButton *lineButton;
@property (weak) IBOutlet NSColorWell *shapeColor;
@property (weak) IBOutlet NSSlider *shapeTransparency;
@property (weak) IBOutlet NSSlider *lineWidth;
@property (weak) IBOutlet NSColorWell *lineColor;
@property (weak) IBOutlet NSTextField *transparencyLabel;
@property (weak) IBOutlet NSTextField *lineWidthLabel;

@end

@implementation SVPreferenceViewController

+(void)setDefaultPreferences{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              SVPrefShapeColor: [[NSColor lightGrayColor] rgbComponents],
                                                              SVPrefShapeTransparency: @(0.5),
                                                              SVPrefDrawLine:@(NO),
                                                              SVPrefLineColor:[[NSColor whiteColor] rgbComponents],
                                                              SVPrefLineWidth:@(1),
                                                              }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self preferencesToUI];
    [self updateLabels];
    
}

-(void)updateLabels{
    self.transparencyLabel.stringValue = [NSString stringWithFormat:@"%.0f%%", self.shapeTransparency.doubleValue];
    self.lineWidthLabel.stringValue = [NSString stringWithFormat:@"%.0f pt", self.lineWidth.doubleValue];
}

-(void)preferencesToUI{
    //
    NSColor * color = [NSColor colorWithRgbComponents:[[NSUserDefaults standardUserDefaults] objectForKey:SVPrefShapeColor] andAlpha:1.0];
    if (color) {
        self.shapeColor.color = color;
    }
    self.shapeTransparency.doubleValue = [[NSUserDefaults standardUserDefaults] doubleForKey:SVPrefShapeTransparency]*100.0;
    self.lineButton.state = [[NSUserDefaults standardUserDefaults] boolForKey:SVPrefDrawLine] ? NSOnState : NSOffState;
    color = [NSColor colorWithRgbComponents:[[NSUserDefaults standardUserDefaults] objectForKey:SVPrefLineColor] andAlpha:1.0];
    if (color) {
        self.lineColor.color = color;
    }
    self.lineWidth.doubleValue = [[NSUserDefaults standardUserDefaults] doubleForKey:SVPrefLineWidth];
}

- (IBAction)preferenceChanged:(id)sender {

    if (self.lineButton.state == NSOnState) {
        self.lineWidth.enabled = true;
        self.lineColor.enabled = true;

    }else{
        self.lineWidth.enabled = false;
        self.lineColor.enabled = false;
    }
    [self updateLabels];
    
    [[NSUserDefaults standardUserDefaults] setObject:[self.shapeColor.color rgbComponents] forKey:SVPrefShapeColor];
    [[NSUserDefaults standardUserDefaults] setDouble:self.shapeTransparency.doubleValue/100.0  forKey:SVPrefShapeTransparency];
    [[NSUserDefaults standardUserDefaults] setBool:self.lineButton.state == NSOnState forKey:SVPrefDrawLine];
    [[NSUserDefaults standardUserDefaults] setObject:[self.lineColor.color rgbComponents] forKey:SVPrefLineColor];
    [[NSUserDefaults standardUserDefaults] setDouble:self.lineWidth.doubleValue forKey:SVPrefLineWidth];
    [[NSNotificationCenter defaultCenter] postNotificationName:SVNotifyPreferenceChanged object:self];
}

@end
