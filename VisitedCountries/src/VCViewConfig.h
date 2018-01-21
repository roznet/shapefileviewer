//
//  VCViewConfig.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 29/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "RZUtils/RZUtils.h"
#import "RZUtilsTouch/RZUtilsTouch.h"
@interface VCViewConfig : RZViewConfig

+(RZFont*)systemFontOfSize:(CGFloat)size;
+(RZFont*)boldSystemFontOfSize:(CGFloat)size;

@end
