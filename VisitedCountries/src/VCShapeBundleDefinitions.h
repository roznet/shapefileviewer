//
//  VCShapeBundleDefinitions.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 16/05/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCShapeSetDefinition.h"

typedef NS_ENUM(NSUInteger, vcShapeBundleDefinition) {
    shapeBundleCountries,
    shapeBundleFrance,
    shapeBundleJapan,
    shapeBundleUnitedState,
    shapeBundleUnitedKingdom,
    shapeBundleNone
};

@interface VCShapeBundleDefinitions : NSObject

+(vcShapeBundleDefinition)bundleDefinitionForName:(NSString*)name;
+(NSString*)definitionNameFor:(vcShapeBundleDefinition)def;
+(VCShapeSetDefinition*)definitionFor:(vcShapeBundleDefinition)def;
+(NSDictionary*)definitionsDictionary;
@end
