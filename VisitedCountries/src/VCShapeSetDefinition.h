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

#import <Foundation/Foundation.h>
@import RZUtils;
@import RZExternalUniversal;
@class VCShape;

@interface VCShapeSetDefinition : NSObject
@property (nonatomic,retain) NSString * definitionName;

@property (nonatomic,retain) NSString * nameField;
@property (nonatomic,retain) NSString * groupField;
@property (nonatomic,retain) NSString * uniqueIdentifierField;
@property (nonatomic,retain) NSString * iconField;
@property (nonatomic,retain) NSString * iconBundle;

@property (nonatomic,retain) NSString * shapefileBaseName;
@property (nonatomic,readonly) RZShapeFile * shapefile;

+(VCShapeSetDefinition*)shapeSetDefinitionWithDict:(NSDictionary*)dict;
+(VCShapeSetDefinition*)shapeSetDefinitionWithResultSet:(FMResultSet*)res;

-(NSArray<VCShape*>*)shapesInFile;
-(NSIndexSet*)indexSetForShapeMatching:(shapeMatchingFunc)match;

+(void)ensureDbStructure:(FMDatabase*)db;

@end
