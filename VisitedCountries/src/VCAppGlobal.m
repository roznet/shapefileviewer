//
//  VCAppGlobal.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 21/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "VCAppGlobal.h"

#if TARGET_OS_IPHONE
#import "VCAppDelegate.h"
#define VCAPPDELEGATE (VCAppDelegate*)[[UIApplication sharedApplication] delegate]
#else

#endif


@implementation VCAppGlobal

+(dispatch_queue_t)worker{
    return [VCAPPDELEGATE worker];
}
+(FMDatabase*)db{
    return [VCAPPDELEGATE db];
}

+(RZShapeFile*)worldShape{
    return [VCAPPDELEGATE worldShape];
}

+(VCShapeSetOrganizer*)organizer{
    return [VCAPPDELEGATE organizer];
}

@end
