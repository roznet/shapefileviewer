//
//  VCShapeSetChoice.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 24/09/2018.
//  Copyright © 2018 Brice Rosenzweig. All rights reserved.
//

#import <Foundation/Foundation.h>
@import RZUtils;
#import "VCShapeBundleDefinitions.h"

@interface VCShapeSetChoice : NSObject
@property (nonatomic,retain) NSString * selectionName;
@property (nonatomic,retain) NSString * definitionName;

@property (nonatomic,retain) NSDate * modified;
@property (nonatomic,readonly) VCShapeSetDefinition * definition;

+(VCShapeSetChoice*)choiceFor:(FMResultSet*)res;
-(void)saveAsCurrent:(FMDatabase*)db;


@end

