//
//  VCAppGlobal.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 21/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

@import RZExternalUniversal;
#import "VCShapeSetOrganizer.h"
@import RZUtils;

@interface VCAppGlobal : RZAppConfig

+(dispatch_queue_t)worker;
+(FMDatabase*)db;
+(RZShapeFile*)worldShape;
+(VCShapeSetOrganizer*)organizer;

@end
