//  MIT Licence
//
//  Created on 15/05/2015.
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

-(BOOL)isEqual:(id)object{
    if( [object isKindOfClass:self.class]){
        return [self isEqualToSelection:object];
    }
    return false;
}
-(BOOL)isEqualToSelection:(VCShapeSetSelection*)object{
    return [self.selectionName isEqualToString:object.selectionName] && [self.definitionName isEqualToString:object.definitionName] && [self.selection isEqualToIndexSet:object.selection];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"<%@:%@,%@[%@]>", NSStringFromClass(self.class),self.selectionName, self.definitionName, @(self.selection.count)];
}

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
