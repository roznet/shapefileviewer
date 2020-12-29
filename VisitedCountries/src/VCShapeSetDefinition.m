//  MIT Licence
//
//  Created on 14/05/2015.
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

#import "VCShapeSetDefinition.h"
#import "VCShape.h"
@import RZUtils;

/*
* VCShapeSetDefinition
*   SetName (ex Countries,French Department)
*   ShapeFileBase (file name)
*   NameField (ex NAME)
*   GroupField ( ex Continent, Region, etc)
*   UniqueIdentifierField (ex ISO2)
*   IconField (ex ISO2)
*   IconBundle (ex flags.bundle)
*/

@interface VCShapeSetDefinition ()
@property (nonatomic,retain) NSString * customClassName;
@property (nonatomic,retain) RZShapeFile * shapefile;

@end

@implementation VCShapeSetDefinition

+(VCShapeSetDefinition*)shapeSetDefinitionWithDict:(NSDictionary*)dict{
    VCShapeSetDefinition * rv = RZReturnAutorelease([[VCShapeSetDefinition alloc] init]);
    if (rv) {
        rv.definitionName = dict[@"setName"];
        rv.nameField = dict[@"nameField"];
        rv.groupField = dict[@"groupField"];
        rv.uniqueIdentifierField = dict[@"uniqueIdentifierField"];
        rv.iconField = dict[@"iconField"];
        rv.iconBundle = dict[@"iconBundle"];
        rv.customClassName = dict[@"customClassName"];
        rv.shapefileBaseName = dict[@"shapefileBaseName"];
        [rv setupFile];
    }
    return rv;
}

+(VCShapeSetDefinition*)shapeSetDefinitionWithResultSet:(FMResultSet*)res{
    VCShapeSetDefinition * rv = RZReturnAutorelease([[VCShapeSetDefinition alloc] init]);
    if (rv) {
        rv.nameField = [res stringForColumn:@"nameField"];
        rv.groupField = [res stringForColumn:@"groupField"];
        rv.uniqueIdentifierField = [res stringForColumn:@"uniqueIdentifierField"];
        rv.iconField = [res stringForColumn:@"iconField"];
        rv.iconBundle = [res stringForColumn:@"iconBundle"];
        rv.customClassName = [res stringForColumn:@"customClassName"];
        rv.definitionName = [res stringForColumn:@"definitionName"];
        rv.shapefileBaseName = [res stringForColumn:@"shapefileBaseName"];
        [rv setupFile];
    }
    return rv;
}

-(BOOL)isEqual:(id)object{
    return [object isKindOfClass:[self class]] ? [self isEqualToDefinition:object] : false;
}
-(BOOL)isEqualToDefinition:(VCShapeSetDefinition*)other{
    return [self.definitionName isEqualToString:other.definitionName] && [self.nameField isEqualToString:other.nameField] && [self.shapefileBaseName isEqualToString:other.shapefileBaseName];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"<%@:%@,%@,%@>", NSStringFromClass(self.class), self.definitionName, self.nameField, self.shapefileBaseName];
}

#if ! __has_feature(objc_arc)
// dealloc
#endif

+(void)ensureDbStructure:(FMDatabase*)db{
    if (![db tableExists:@"vc_sets_definitions"]) {
        RZEXECUTEUPDATE(db, @"CREATE TABLE vc_sets_definitions (definitionName TEXT UNIQUE, nameField TEXT,  groupField TEXT, uniqueIdentifierField TEXT, iconField TEXT, iconBundle TEXT, customClassName TEXT, shapefileBaseName TEXT)");

    }
}

-(void)saveToDb:(FMDatabase*)db{
    [db beginTransaction];
    RZEXECUTEUPDATE(db, @"INSERT OR REPLACE INTO vc_sets_definitions (definitionName, nameField,  groupField, uniqueIdentifierField, iconField, iconBundle, customClassName, shapefileBaseName) VALUES (?,?,?,?,?,?,?,?)",
                    self.definitionName,
                    self.nameField,
                    self.groupField,
                    self.uniqueIdentifierField,
                    self.iconField,
                    self.iconBundle,
                    self.customClassName,
                    self.shapefileBaseName);
    [db commit];

}
#pragma mark - ShapeFile

-(void)setupFile{
    NSString * path = [self shapefilePath];
    if (path) {
        self.shapefile = [RZShapeFile shapeFileWithBase:path];
    }
}

-(NSString*)shapefilePath{
    NSString * rv = nil;
    NSString * shp = [self.shapefileBaseName stringByAppendingPathExtension:@"shp"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:shp]) {
        rv = self.shapefileBaseName;
    }
    if (rv == nil && [RZFileOrganizer writeableFilePathIfExists:shp]) {
        rv = [RZFileOrganizer writeableFilePath:self.shapefileBaseName];
    }
    if (rv == nil && [RZFileOrganizer bundleFilePathIfExists:shp]) {
        rv = [RZFileOrganizer bundleFilePath:self.shapefileBaseName];
    }

    return rv;
}

-(NSArray<VCShape*>*)shapesInFile{
    NSMutableArray * rv = nil;
    if (self.shapefile) {
        NSArray * shapes = [self.shapefile allShapes];
        rv = [NSMutableArray arrayWithCapacity:shapes.count];
        NSUInteger idx = 0;
        Class cls = self.customClassName ? NSClassFromString(self.customClassName) : [VCShape class];
        for (NSDictionary * vals in shapes) {
            id obj = [cls shapeWithValues:vals atIndex:idx++ withDefs:self];
            [rv addObject:obj];
        }
    }
    return  rv;
}

-(NSIndexSet*)indexSetForShapeMatching:(shapeMatchingFunc)match{
    NSIndexSet * rv = nil;
    if (self.shapefile) {
        rv = [self.shapefile indexSetForShapeMatching:match];
    }
    return rv;
}
@end
