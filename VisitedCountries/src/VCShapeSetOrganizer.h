//
//  VCCountriesListOrganizer.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 26/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZShapeFile.h"
#import "RZUtils/RZUtils.h"
#import "VCShapeSetSelection.h"


@interface VCShapeSetOrganizer : RZParentObject

@property (nonatomic,retain) VCShapeSetSelection * setSelection;

+(VCShapeSetOrganizer*)organizerWithDatabase:(FMDatabase*)db andThread:(dispatch_queue_t)th;


-(void)addDefinition:(VCShapeSetDefinition*)def;
-(VCShapeSetDefinition*)definitionForName:(NSString*)defname;
-(NSArray*)allDefinitionNames;

-(void)newSelectionName:(NSString*)selname withDefinitionName:(NSString*)defname;
-(void)loadSelectionName:(NSString*)selname withDefinitionName:(NSString*)defname;

-(NSIndexSet*)indexSetForSelection;
-(void)setIndexSetForSelection:(NSIndexSet*)selection;

-(NSArray*)list;

+(void)ensureDbStructure:(FMDatabase*)db;



@end
