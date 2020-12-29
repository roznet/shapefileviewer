//  MIT Licence
//
//  Created on 14/05/2015.
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

#import "VCShape.h"
@import RZUtils;

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
