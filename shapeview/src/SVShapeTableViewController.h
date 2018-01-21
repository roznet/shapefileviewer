//
//  SVShapeTableViewController.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 29/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MapKit/MapKit.h>
@interface SVShapeTableViewController : NSViewController<NSOutlineViewDataSource,NSTableViewDataSource,NSTableViewDelegate,MKMapViewDelegate,NSTextFieldDelegate>

@end
