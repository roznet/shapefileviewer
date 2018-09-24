//  MIT Licence
//
//  Created on 16/05/2015.
//
//  Copyright (c) 2015 Brice Rosenzweig.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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

+(NSDictionary<NSString*,VCShapeSetDefinition*>*)definitionsDictionary{
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
+(VCShapeSetDefinition*)definitionForName:(NSString*)name{
    
    return [VCShapeBundleDefinitions definitionsDictionary][name];
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
