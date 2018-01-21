//
//  AppDelegate.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 16/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZShapeFile.h"
#import "RZUtils/RZUtils.h"
#import "VCShapeSetOrganizer.h"

@interface VCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) RZShapeFile * worldShape;

@property (nonatomic,retain)  dispatch_queue_t worker;
@property (nonatomic,retain) FMDatabase * db;
@property (nonatomic,retain) VCShapeSetOrganizer * organizer;
@end

