//  MIT Licence
//
//  Created on 26/03/2015.
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
#import "VCShapeSetChoice.h"

@interface VCShapeSetOrganizer ()

@property (nonatomic,retain) dispatch_queue_t worker;
@property (nonatomic,retain) FMDatabase * db;

@property (nonatomic,retain) NSDictionary<NSString*,VCShapeSetDefinition*> * definitions;
@property (nonatomic,retain) NSArray<VCShapeSetChoice*> * validChoices;

@property (nonatomic,retain) VCShapeSetChoice * currentChoice;

@property (nonatomic,retain) VCShapeSetSelection * setSelection;
//@property (nonatomic,readonly) VCShapeSetDefinition * setDefinition;
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
    
    [self loadCurrentSelectionAndDefinitionName];
    
    self.setSelection = [VCShapeSetSelection shapeSelectionWithName:self.currentChoice.selectionName andDefinitions:self.setDefinition];
    
    [self loadCurrentChoice];
}

-(void)loadCurrentSelectionAndDefinitionName{
    FMResultSet * res = [self.db executeQuery:@"SELECT * FROM vc_sets WHERE current = 1 ORDER BY modified DESC LIMIT 1 "];
    if( [res next]){
        self.currentChoice = [VCShapeSetChoice choiceFor:res];
    }else{
        // none with current = 0, set first one to 1;
        res = [self.db executeQuery:@"SELECT * FROM vc_sets ORDER BY modified DESC LIMIT 1"];
        if( [res next]){
            self.currentChoice = [VCShapeSetChoice choiceFor:res];
        }
        [self.currentChoice saveAsCurrent:self.db];
    }
    NSMutableArray * choices = [NSMutableArray
                                array];
    res = [self.db executeQuery:@"SELECT * FROM vc_sets ORDER BY modified DESC"];
    while( [res next]){
        [choices addObject:[VCShapeSetChoice choiceFor:res]];
    }
    [choices sortUsingComparator:^(VCShapeSetChoice * c1, VCShapeSetChoice * c2){
        return [c2.modified compare:c1.modified];
    }];
    self.validChoices = choices;
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
        RZEXECUTEUPDATE(db, @"CREATE TABLE vc_sets (definitionName TEXT, selectionName TEXT, current INT DEFAULT 0, valid INT DEFAULT 1, modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP )");
        RZEXECUTEUPDATE(db, @"INSERT INTO vc_sets (definitionName, selectionName) VALUES( 'Countries', 'Default')");
    }


}

#pragma mark - Definitions

-(VCShapeSetDefinition*)definitionForName:(NSString*)defname{
    return self.definitions[defname];
}
-(NSArray<NSString*>*)allDefinitionNames{
    return self.definitions.allKeys;
}
-(RZShapeFile*)shapeFile{
    return self.setDefinition.shapefile;
}
-(VCShapeSetDefinition*)setDefinition{
    return self.definitions[self.currentChoice.definitionName];
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


-(BOOL)changeCurrentChoice:(VCShapeSetChoice*)newChoice{
    if( [newChoice isEqualToChoice:self.currentChoice] ){
        return true;
    }else{
        for (VCShapeSetChoice * one in self.validChoices) {
            if( [one isEqualToChoice:newChoice]){
                self.currentChoice = newChoice;
                [self loadCurrentChoice];
                
                return true;
            }
        }
    }
    
    return false;
    
}

-(BOOL)loadCurrentChoice{
    [self executeDbBlock:^(){
        VCShapeSetDefinition * def = self.setDefinition;
        NSString * selectionName= self.currentChoice.selectionName;
        NSString * definitionName = self.currentChoice.definitionName;
        if (def) {
            FMResultSet * res = [self.db executeQuery:@"SELECT * FROM vc_sets WHERE definitionName = ? AND selectionName = ?",definitionName,selectionName];
            if ([res next]) {
                self.setSelection = [VCShapeSetSelection shapeSelectionWithName:selectionName
                                                                 andDefinitions:def];
                [self.setSelection loadFromDb:self.db];
            }else{
                self.setSelection = [VCShapeSetSelection shapeSelectionWithName:selectionName andDefinitions:def];
                RZEXECUTEUPDATE(self.db, @"INSERT INTO vc_sets (definitionName,selectionName) VALUES (?,?)", definitionName,selectionName);
            }
            [self notify];
        }
    }];
    return TRUE;
}

@end
