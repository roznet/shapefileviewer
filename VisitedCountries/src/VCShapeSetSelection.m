//
//  VCShapeSet.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 15/05/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "RZUtils/RZUtils.h"
#import "VCShapeSetSelection.h"
#import "VCShapeSetDefinition.h"
#import "VCShape.h"

@interface VCShapeSetSelection ()
@property (nonatomic,retain) NSString * selectionName;
@property (nonatomic,retain) NSString * definitionName;
@property (nonatomic,retain) VCShapeSetDefinition * setDefinition;

@end

@implementation VCShapeSetSelection

+(VCShapeSetSelection*)shapeSelectionWithName:(NSString*)name andDefinitionName:(NSString*)defs{
    VCShapeSetSelection * rv = RZReturnAutorelease([[VCShapeSetSelection alloc] init]);
    if (rv) {
        rv.definitionName = defs;
        rv.selectionName = name;
    }
    return rv;
}

+(VCShapeSetSelection*)shapeSelectionWithName:(NSString*)name andDefinitions:(VCShapeSetDefinition*)defs{
    VCShapeSetSelection * rv = RZReturnAutorelease([[VCShapeSetSelection alloc] init]);
    if (rv) {
        rv.selectionName = name;
        rv.definitionName = defs.definitionName;
        rv.setDefinition = defs;
        rv.list = [defs shapesInFile];
    }
    return rv;
    
}

#if ! __has_feature(objc_arc)
// dealloc
#endif

#pragma mark - database

+(void)ensureDbStructure:(FMDatabase*)db{
    [VCShapeSetDefinition ensureDbStructure:db];
    if (![db tableExists:@"vc_sets_selections"]) {
        RZEXECUTEUPDATE(db, @"CREATE TABLE vc_sets_selections (definitionName TEXT, selectionName TEXT, uniqueIdentifier TEXT)");
    }
}

-(void)saveToDb:(FMDatabase*)db{
    [db beginTransaction];
    RZEXECUTEUPDATE(db, @"DELETE FROM vc_sets_selections WHERE definitionName = ? AND selectionName = ?",
                    self.setDefinition.definitionName, self.selectionName);
    [self.list enumerateObjectsAtIndexes:self.selection options:0 usingBlock:^(VCShape*obj, NSUInteger idx, BOOL * stop){
        RZEXECUTEUPDATE(db, @"INSERT INTO vc_sets_selections (definitionName,selectionName,uniqueIdentifier) VALUES (?,?,?)",
                        self.setDefinition.definitionName,self.selectionName,obj.uniqueIdentifier);
    }];
    [db commit];
}

-(void)loadFromDb:(FMDatabase*)db{
    NSMutableDictionary * selectedIdentifier = [NSMutableDictionary dictionary];
    FMResultSet * set = [db executeQuery:@"SELECT * FROM vc_sets_selections WHERE definitionName = ? AND selectionName = ?",
                         self.setDefinition.definitionName,self.selectionName];
    while ([set next]) {
        selectedIdentifier[ [set stringForColumn:@"uniqueIdentifier"]] = @(1);
    }
    
    NSMutableIndexSet * selected = [NSMutableIndexSet indexSet];
    [self.list enumerateObjectsUsingBlock:^(VCShape*obj, NSUInteger idx, BOOL * stop){
        if (selectedIdentifier[obj.uniqueIdentifier]) {
            [selected addIndex:idx];
        }
    } ];
    self.selection = selected;
    
}

-(void)setSelectionForShapeMatching:(shapeMatchingFunc)match{
    self.selection = [self.setDefinition indexSetForShapeMatching:match];
}
@end
