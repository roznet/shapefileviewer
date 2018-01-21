//
//  VCShapeBundleDefinitions.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 16/05/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "VCShapeBundleDefinitions.h"


@implementation VCShapeBundleDefinitions

+(NSArray*)definitions{
    static NSArray * defs = nil;
    if (defs == nil) {
        defs = @[
                 // In Order of vcShapeBundleDefinition
                 @{
                     @"setName" : @"Countries",
                     @"nameField" : @"NAME",
                     @"groupField" : @"REGION",
                     @"uniqueIdentifierField" : @"ISO2",
                     @"iconField" : @"ISO2",
                     @"iconBundle" : @"flags.bundle",
                     @"customClassName" : @"VCShapeCountry",
                     @"shapefileBaseName": @"TM_WORLD_BORDERS-0.2",
                     
                     
                     },
                 @{
                     @"setName" : @"France",
                     @"nameField" : @"nom",
                     @"uniqueIdentifierField" : @"wikipedia",
                     @"shapefileBaseName": @"regions-20140306-100m",
                     
                     },
                 
                 @{
                     @"setName" : @"Japan",
                     @"nameField" : @"NAME_1",
                     @"groupField" : @"NAME_0",
                     @"uniqueIdentifierField" : @"HASC_1",
                     @"shapefileBaseName": @"JPN_Adm1",
                     },
                 @{
                     @"setName" : @"United States",
                     @"nameField" : @"STATE_NAME",
                     @"groupField" : @"SUB_REGION",
                     @"uniqueIdentifierField" : @"STATE_ABBR",
                     @"shapefileBaseName": @"states",
                     },
                 @{
                     @"setName" : @"United Kingdom",
                     @"nameField" : @"NAME_1",
                     @"uniqueIdentifierField" : @"HASC_1",
                     @"shapefileBaseName": @"GBR_Adm1",
                     },
                 
                 ];
        
    }
    return defs;
}

+(NSDictionary*)definitionsDictionary{
    static NSMutableDictionary * rv = nil;
    if (rv==nil) {
        NSArray * all = [VCShapeBundleDefinitions definitions];
        rv = [[NSMutableDictionary alloc] initWithCapacity:all.count];
        for (NSDictionary * one in all) {
            rv[one[@"setName"]] = [VCShapeSetDefinition shapeSetDefinitionWithDict:one];
        }
    }
    return rv;
}
+(vcShapeBundleDefinition)bundleDefinitionForName:(NSString*)name{
    vcShapeBundleDefinition rv = shapeBundleCountries;
    
    for (NSDictionary * one in [VCShapeBundleDefinitions definitions]) {
        if ([name isEqualToString:one[@"setName"]]) {
            break;
        }
        rv++;
    }
    return rv;
}

+(NSString*)definitionNameFor:(vcShapeBundleDefinition)def{
    return [VCShapeBundleDefinitions definitions][def][@"setName"];
}

+(VCShapeSetDefinition*)definitionFor:(vcShapeBundleDefinition)def{
    VCShapeSetDefinition * rv = nil;
    if (def < shapeBundleNone) {
        NSDictionary * dict = [VCShapeBundleDefinitions definitions][def];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            rv = [VCShapeSetDefinition shapeSetDefinitionWithDict:dict];
        }
    }
    return rv;
}

@end
