//
//  VCCountriesListOrganizer.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 26/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

/*
 * VCListOrganizer
 *   SetList: Array( VCShapeSetDefinition )
 *   ShapeList: Array( VCShape )
 *   ShapeSelection: NSIndexSet
 *
 *   NewShapeSelection( selectionName:NSString, Set:VCShapeSetDefinition )
 *   UseShapeSelection( selectionName:NSString )
 *
 *
 * VCShape
 *   Name
 *   Group
 *   UniqueIdentifier
 *   IconPath
 *   IconImage
 *   SetDefinition: VCShapeSetDefinition
 *
 * VCShapeSetDefinition
 *   SetName (ex Countries,French Department)
 *   ShapeFileBase (file name)
 *   NameField (ex NAME)
 *   GroupField ( ex Continent, Region, etc)
 *   UniqueIdentifierField (ex ISO2)
 *   IconField (ex ISO2)
 *   IconBundle (ex flags.bundle)
 *   
 * As Json
 *
 {
 "SetName" : "Countries",
 "ShapeFileBase" : "",
 "NameField" : "NAME",
 "GroupField" : "REGION",
 "UniqueIdentifierField" : "ISO2",
 "IconField" : "ISO2",
 "IconBundle" : "",
 "CustomClass" : "VCCountry"
 }
 */

#import "RZUtils/RZUtils.h"
#import "VCShapeSetOrganizer.h"
#import "VCCountry.h"
#import "VCShapeBundleDefinitions.h"

@interface VCShapeSetOrganizer ()

@property (nonatomic,retain) dispatch_queue_t worker;
@property (nonatomic,retain) FMDatabase * db;

@property (nonatomic,retain) NSDictionary * definitions;

@end

@implementation VCShapeSetOrganizer


+(VCShapeSetOrganizer*)organizerWithDatabase:(FMDatabase*)db andThread:(dispatch_queue_t)th{
    VCShapeSetOrganizer * rv = [[VCShapeSetOrganizer alloc] init];
    if (rv) {
        rv.worker = th;
        rv.db = db;
        
        [rv loadFromDb];
    }
    
    return rv;
}

-(void)loadFromDb{
    self.definitions = [VCShapeBundleDefinitions definitionsDictionary];
    self.setSelection = [VCShapeSetSelection shapeSelectionWithName:@"Countries" andDefinitions:self.definitions[@"Countries"]];
}
#pragma mark - Properties

-(NSArray*)list{
    return self.setSelection.list;
}

-(NSIndexSet*)indexSetForSelection{
    return self.setSelection.selection;
}

-(void)setIndexSetForSelection:(NSIndexSet*)selection{
    self.setSelection.selection = selection;
    [self executeDbBlock:^(){
        [self.setSelection saveToDb:self.db];
        [self performSelectorOnMainThread:@selector(notify) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark - database

+(void)ensureDbStructure:(FMDatabase*)db{
    [VCShapeSetSelection ensureDbStructure:db];
    if (![db tableExists:@"vc_sets"]) {
        RZEXECUTEUPDATE(db, @"CREATE TABLE vc_sets (definitionName TEXT, selectionName TEXT)");
    }

    
}

-(void)changeSelectionName:(NSString*)name{
    
}
-(void)changeSetSelection:(VCShapeSetDefinition*)setSelection{
    
}

#pragma mark - Definitions




-(void)addDefinition:(VCShapeSetDefinition*)def{
    
}
-(VCShapeSetDefinition*)definitionForName:(NSString*)defname{
    return self.definitions[defname];
}
-(NSArray*)allDefinitionNames{
    return self.definitions.allKeys;
}

#pragma mark - Selections

-(void)executeDbBlock:(void (^)(void))block{
    if (self.db) {
        if (self.worker) {
            dispatch_async(self.worker, block);
        }else{
            block();
        }
    }
}

-(BOOL)chooseSelectionName:(NSString*)selname withDefinitionName:(NSString*)defname{
    [self executeDbBlock:^(){
        VCShapeSetDefinition * def = [self definitionForName:defname];
        if (def) {
            FMResultSet * res = [self.db executeQuery:@"SELECT * FROM vc_sets WHERE definitionName = ? AND selectionName = ?",defname,selname];
            if ([res next]) {
                self.setSelection = [VCShapeSetSelection shapeSelectionWithName:selname andDefinitions:def];
                [self.setSelection loadFromDb:self.db];
            }else{
                self.setSelection = [VCShapeSetSelection shapeSelectionWithName:selname andDefinitions:def];
                RZEXECUTEUPDATE(self.db, @"INSERT INTO vc_sets (definitionName,selectionName) VALUES (?,?)", defname,selname);
            }
        }
    }];
    return TRUE;
}


-(void)newSelectionName:(NSString*)selname withDefinitionName:(NSString*)defname{
    [self chooseSelectionName:selname withDefinitionName:defname];
}
-(void)loadSelectionName:(NSString*)selname withDefinitionName:(NSString*)defname{
    [self chooseSelectionName:selname withDefinitionName:defname];    
}

@end
