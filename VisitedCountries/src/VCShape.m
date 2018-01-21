//
//  VCShape.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 14/05/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "VCShape.h"
#import "RZUtils/RZUtils.h"

/*
* VCShape
*   Name
*   Group
*   UniqueIdentifier
*   IconPath
*   IconImage
*   SetDefinition: VCShapeSetDefinition
*/
@interface VCShape ()

@property (nonatomic,retain) RZShapeFile * shapefile;
@property (nonatomic,assign) NSUInteger shapeIndex;
@property (nonatomic,retain) NSString * iconName;

@property (nonatomic,retain) VCShapeSetDefinition * definitions;
@property (nonatomic,retain) NSDictionary * values;

@end

@implementation VCShape
+(instancetype)shapeWithValues:(NSDictionary*)vals atIndex:(NSUInteger)idx withDefs:(VCShapeSetDefinition*)defs{
    VCShape * rv = RZReturnAutorelease([[self alloc] init]);
    if (rv) {
        rv.definitions = defs;
        rv.values = vals;

        rv.shapeIndex = idx;
        rv.name = vals[defs.nameField];
        rv.group = vals[defs.groupField];
        rv.uniqueIdentifier = vals[defs.uniqueIdentifierField];
        
        for (NSString * key in @[ @"name", @"group", @"uniqueIdentifier"]) {
            id val = [rv valueForKey:key];
            if (![val isKindOfClass:[NSString class]]) {
                if ([val respondsToSelector:@selector(stringValue)]) {
                    [rv setValue:[val stringValue] forKey:key];
                }
            }
        }
        
    }
    return rv;
}
#if ! __has_feature(objc_arc)
// dealloc
#endif

-(NSString*)description{
    return[NSString stringWithFormat:@"<%@(%@,%d):%@:%@>", NSStringFromClass(self.class), self.uniqueIdentifier,(int)self.shapeIndex, self.name, self.group];
}

-(BOOL)matchString:(NSString *)str{
    return [[self.name uppercaseString] containsString:[str uppercaseString]] || [[self.group uppercaseString] containsString:[str uppercaseString]];
}

-(NSString*)iconName{
    NSString * rv = nil;
    if (self.definitions.iconField) {
        rv = [NSString stringWithFormat:@"%@/%@", self.definitions.iconBundle, self.values[self.definitions.iconField]];
    }
    return rv;
}
@end
