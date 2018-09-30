//
//  VCShapeSetChoice.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 24/09/2018.
//  Copyright © 2018 Brice Rosenzweig. All rights reserved.
//

#import "VCShapeSetChoice.h"
@import RZUtils;

@implementation VCShapeSetChoice

+(VCShapeSetChoice*)choiceFor:(FMResultSet*)res{
    
    VCShapeSetChoice * rv = [[VCShapeSetChoice alloc] init];
    rv.selectionName = [res stringForColumn:@"selectionName"];
    rv.definitionName = [res stringForColumn:@"definitionName"];
    rv.modified = [res dateForColumn:@"timestamp"];

    return rv;
}

+(VCShapeSetChoice*)choiceForDefinition:(NSString*)defName andName:(NSString*)selName{
    VCShapeSetChoice * rv = [[VCShapeSetChoice alloc] init];
    rv.selectionName = selName;
    rv.definitionName = defName;
    rv.modified = [NSDate date];
    
    return rv;
}

-(BOOL)isEqual:(id)object{
    return [object isKindOfClass:self.class] ? [self isEqualToChoice:object] : false;
}

-(BOOL)isEqualToChoice:(VCShapeSetChoice*)other{
    
    return [self.selectionName isEqualToString:other.selectionName] &&
    [self.definitionName isEqualToString:other.definitionName];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"<%@[%@,%@]>", NSStringFromClass([self class]), self.selectionName, self.definitionName];
}

-(void)saveAsCurrent:(FMDatabase*)db{
    FMResultSet * res = [db executeQuery:@"SELECT * FROM vc_sets WHERE selectionName = ? AND definitionName = ?", self.selectionName, self.definitionName];
    if( [res next] ){
        RZEXECUTEUPDATE(db, @"UPDATE vc_sets SET valid = 1, timestamp = ? WHERE selectionName = ? AND definitionName = ?", self.modified, self.selectionName, self.definitionName);
    }else{
        RZEXECUTEUPDATE(db, @"INSERT INTO vc_sets  (selectionName, definitionName, valid, timestamp) VALUES (?,?,1,?)",
                        self.selectionName, self.definitionName,self.modified);
    }
}
@end
