//
//  VCViewConfig.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 29/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "VCViewConfig.h"

@implementation VCViewConfig

+(RZFont*)systemFontOfSize:(CGFloat)size{
    return [RZFont fontWithName:@"ChalkboardSE-Light" size:size];
    //return [RZFont fontWithName:@"HelveticaNeue-Light" size:size];
}
+(RZFont*)boldSystemFontOfSize:(CGFloat)size{
    return [RZFont fontWithName:@"ChalkboardSE-Bold" size:size];
    //return [RZFont fontWithName:@"HelveticaNeue" size:size];
}

@end
