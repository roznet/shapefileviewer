//
//  VCShape.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 14/05/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Foundation/Foundation.h>
@import RZExternalUniversal;
#import "VCShapeSetDefinition.h"

@interface VCShape : NSObject
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * group;
@property (nonatomic,retain) NSString * uniqueIdentifier;


+(instancetype)shapeWithValues:(NSDictionary*)vals atIndex:(NSUInteger)idx withDefs:(VCShapeSetDefinition*)defs;
-(BOOL)matchString:(NSString *)str;
-(NSString*)iconName;

@end
