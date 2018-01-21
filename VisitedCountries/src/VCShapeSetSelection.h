//
//  VCShapeSet.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 15/05/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZUtils/RZUtils.h"
#import "VCShapeSetDefinition.h"


@interface VCShapeSetSelection : NSObject

@property (nonatomic,retain) NSArray * list;
@property (nonatomic,retain) NSIndexSet * selection;

+(VCShapeSetSelection*)shapeSelectionWithName:(NSString*)name andDefinitionName:(NSString*)defsName;
+(VCShapeSetSelection*)shapeSelectionWithName:(NSString*)name andDefinitions:(VCShapeSetDefinition*)defs;


+(void)ensureDbStructure:(FMDatabase*)db;
-(void)saveToDb:(FMDatabase*)db;
-(void)loadFromDb:(FMDatabase*)db;

-(void)setSelectionForShapeMatching:(shapeMatchingFunc)match;

@end
