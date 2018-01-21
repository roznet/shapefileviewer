//
//  VCShapeSetDefinition.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 14/05/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZUtils/RZUtils.h"
#import "RZShapeFile.h"

@interface VCShapeSetDefinition : NSObject
@property (nonatomic,retain) NSString * definitionName;

@property (nonatomic,retain) NSString * nameField;
@property (nonatomic,retain) NSString * groupField;
@property (nonatomic,retain) NSString * uniqueIdentifierField;
@property (nonatomic,retain) NSString * iconField;
@property (nonatomic,retain) NSString * iconBundle;

@property (nonatomic,retain) NSString * shapefileBaseName;

+(VCShapeSetDefinition*)shapeSetDefinitionWithDict:(NSDictionary*)dict;
+(VCShapeSetDefinition*)shapeSetDefinitionWithResultSet:(FMResultSet*)res;

-(NSArray*)shapesInFile;
-(NSIndexSet*)indexSetForShapeMatching:(shapeMatchingFunc)match;

+(void)ensureDbStructure:(FMDatabase*)db;

@end
