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
    rv.modified = [NSDate dateForSQLiteFormat:[res stringForColumn:@"modified"]];

    return rv;
}

-(BOOL)isEqualToChoice:(VCShapeSetChoice*)other{
    
    return [self.selectionName isEqualToString:other.selectionName] &&
    [self.definitionName isEqualToString:other.definitionName];
}

-(void)saveToDb:(FMDatabase*)db{
    
    RZEXECUTEUPDATE(db, @"UPDATE vc_sets SET current = 1, modified = CURRENT_TIMESTAMP WHERE selectionName = ? AND definitionName = ?", self.selectionName, self.definitionName);

}

-(void)saveAsCurrent:(FMDatabase*)db{
    RZEXECUTEUPDATE(db, @"UPDATE vc_sets SET current = 0" );
    FMResultSet * res = [db executeQuery:@"SELECT * FROM vc_sets WHERE selectionName = ? AND definitionName = ?", self.selectionName, self.definitionName];
    if( [res next] ){
        RZEXECUTEUPDATE(db, @"UPDATE vc_sets SET current = 1, modified = CURRENT_TIMESTAMP WHERE selectionName = ? AND definitionName = ?", self.selectionName, self.definitionName);
    }else{
        RZEXECUTEUPDATE(db, @"INSERT INTO vc_sets  (selectionName, definitionName, current) VALUES (?,?,1)",
                        self.selectionName, self.definitionName);

    }
}
@end
