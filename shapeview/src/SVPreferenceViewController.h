//
//  SVPreferenceViewController.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 03/04/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * SVPrefShapeColor;
extern NSString * SVPrefShapeTransparency;
extern NSString * SVPrefDrawLine;
extern NSString * SVPrefLineColor;
extern NSString * SVPrefLineWidth;
extern NSString * SVNotifyPreferenceChanged;

@interface SVPreferenceViewController : NSViewController

+(void)setDefaultPreferences;

@end
