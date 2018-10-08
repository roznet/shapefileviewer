//
//  VisitedCountriesTests.m
//  VisitedCountriesTests
//
//  Created by Brice Rosenzweig on 16/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@import RZExternalUniversal;
@import RZUtils;

#import "VCShapeSetChoice.h"
#import "VCShapeSetOrganizer.h"

#import "VCShapeSetDefinition.h"
#import "VCShape.h"
#import "VCShapeCountry.h"
#import "VCShapeSetSelection.h"
#import "VCShapeBundleDefinitions.h"

@interface VisitedCountriesTests : XCTestCase

@end

@implementation VisitedCountriesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(NSIndexSet*)myCountrySelectionLong:(NSUInteger)which inSelection:(VCShapeSetSelection*)selection{
    
    NSArray * defs = @[
                       @[ @"CHINA", @"UNITED KINGDOM", @"UNITED STATES", @"FRANCE", @"AUSTRALIA",
                          @"JAPAN", @"GERMANY", @"SWITZERLAND", @"MOROCCO",@"TUNISIA", @"NEW ZEALAND",
                          @"MEXICO", @"SPAIN", @"CZECH", @"CANADA", @"ITALY", @"BELGIUM", @"KOREA, REP",
                          @"VIET NAM",
                          @"MALAYSIA", @"INDONESIA", @"THAILAND", @"PHILIPPINES", @"NETHERLAND", @"TURKEY"],
                       @[ @"CHINA", @"UNITED KINGDOM", @"UNITED STATES", @"FRANCE", @"AUSTRALIA",
                          @"MALAYSIA", @"INDONESIA", @"THAILAND", @"PHILIPPINES", @"RUSSIA", @"KENYA"],

                       ];
    
    NSArray * countries = defs[ MIN(defs.count-1, which)];
    
    [selection setSelectionForShapeMatching:^(NSDictionary*dict){
        BOOL rv = false;
        
        for (NSString * test in countries) {
            if( [[dict[@"NAME"] uppercaseString] containsString:test] ){
                rv = true;
            }
        }
        return rv;
    }];
    return selection.selection;
}

-(NSIndexSet*)myFranceSelectionLong:(NSUInteger)which inSelection:(VCShapeSetSelection*)selection{
    NSArray * defs = @[
                       @[ @"Alsace", @"Corse"],
                       @[ @"Alsace", @"Corse", @"Champagne", @"Lorraine", @"Aquitaine"],
                       ];
    NSArray * countries = defs[MIN(defs.count-1,which) ];
    
    /**/
    
    [selection setSelectionForShapeMatching:^(NSDictionary*dict){
        BOOL rv = false;
        
        for (NSString * test in countries) {
            if( [dict[@"nom"] containsString:test] ){
                rv = true;
            }
        }
        return rv;
    }];
    return selection.selection;
}

- (void)testLoadSaveToDb {
    // This is an example of a functional test case.
    
    //VCShapeSetDefinition * defs = [VCShapeBundleDefinitions definitionFor:shapeBundleCountries];
    [RZFileOrganizer removeEditableFile:@"test_sets.db"];

    FMDatabase * db = [FMDatabase databaseWithPath:[RZFileOrganizer writeableFilePath:@"test_sets.db"]];
    [db open];
    [VCShapeSetOrganizer ensureDbStructure:db];
    
    

    VCShapeSetOrganizer * organizer = [VCShapeSetOrganizer organizerWithDatabase:db andThread:nil];
    NSUInteger startChoicesCount = [organizer validChoices].count;

    [organizer changeCurrentChoice:[VCShapeSetChoice choiceForDefinition:@"Countries" andName:@"Test"]];
    XCTAssertEqual([organizer validChoices].count, startChoicesCount+1);
    XCTAssertEqualObjects([organizer validChoices][0], [VCShapeSetChoice choiceForDefinition:@"Countries" andName:@"Test"]);
    
    NSIndexSet * sel = [self myCountrySelectionLong:true inSelection:organizer.setSelection];
    [organizer setIndexSetForSelection:sel];
    NSUInteger count = organizer.setSelection.selection.count;
    
    [organizer changeCurrentChoice:[VCShapeSetChoice choiceForDefinition:@"Countries" andName:@"Test2"]];
    XCTAssertEqual([organizer validChoices].count, startChoicesCount+2 );
    XCTAssertEqualObjects([organizer validChoices][0], [VCShapeSetChoice choiceForDefinition:@"Countries" andName:@"Test2"]);

    sel = [self myCountrySelectionLong:false inSelection:organizer.setSelection];
    [organizer setIndexSetForSelection:sel];
    NSUInteger count2 = organizer.setSelection.selection.count;
    XCTAssertNotEqual(count2, count);

    [organizer changeCurrentChoice:[VCShapeSetChoice choiceForDefinition:@"Countries" andName:@"Test"]];
    XCTAssertEqual([organizer validChoices].count, startChoicesCount+2 );
    XCTAssertEqual(count, organizer.setSelection.selection.count);
    
    [organizer changeCurrentChoice:[VCShapeSetChoice choiceForDefinition:@"France" andName:@"Test"]];
    XCTAssertEqual([organizer validChoices].count, startChoicesCount+3 );
    XCTAssertEqualObjects([organizer validChoices][0], [VCShapeSetChoice choiceForDefinition:@"France" andName:@"Test"]);

    sel = [self myFranceSelectionLong:false inSelection:organizer.setSelection];
    [organizer setIndexSetForSelection:sel];
    NSUInteger count3 = organizer.setSelection.selection.count;
    
    [organizer changeCurrentChoice:[VCShapeSetChoice choiceForDefinition:@"Countries" andName:@"Test"]];
    XCTAssertEqual(count, organizer.setSelection.selection.count);
    XCTAssertEqualObjects([organizer validChoices][0], [VCShapeSetChoice choiceForDefinition:@"Countries" andName:@"Test"]);

    [organizer changeCurrentChoice:[VCShapeSetChoice choiceForDefinition:@"France" andName:@"Test"]];
    XCTAssertEqual(count3, organizer.setSelection.selection.count);
    XCTAssertEqualObjects([organizer validChoices][0], [VCShapeSetChoice choiceForDefinition:@"France" andName:@"Test"]);

    VCShapeSetOrganizer * reload = [VCShapeSetOrganizer organizerWithDatabase:db andThread:nil];
    XCTAssertEqualObjects(reload.validChoices, organizer.validChoices);
    XCTAssertEqualObjects(reload.setSelection, organizer.setSelection);
    
}

-(void)testReverseLocate{
    FMDatabase * db = [FMDatabase databaseWithPath:[RZFileOrganizer bundleFilePath:@"countries.db" forClass:[self class]]];
    [db open];
    
    NSString * baseName = @"TM_WORLD_BORDERS-0.2";
    RZShapeFile * file = [RZShapeFile shapeFileWithBase:[RZFileOrganizer bundleFilePath:baseName]];
    NSArray * info = [file allShapes];
    FMResultSet * res = [db executeQuery:@"SELECT * FROM countries"];
    NSUInteger failed = 0;
    NSUInteger total = 0;
    NSMutableDictionary * map = [NSMutableDictionary dictionary];
    NSMutableDictionary * mis = [NSMutableDictionary dictionary];
    while ([res next]) {
        
        NSString * location = [res stringForColumn:@"location"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([res doubleForColumn:@"latitude"], [res doubleForColumn:@"longitude"]);
        if ([location containsString:@", "]) {
            total++;
    
            NSArray * split = [location componentsSeparatedByString:@", "];
            NSString * dbLocation = split.lastObject;
            NSIndexSet * set = [file indexSetForShapeContaining:coord];
            NSArray * found = [info objectsAtIndexes:set];
            XCTAssertGreaterThan(found.count, 0, @"%@", location);
            if( found.count > 0){
                NSString * foundName = found[0][@"ISO2"];
                NSNumber * prev = map[foundName];
                if( prev ){
                    map[foundName] = @( prev.doubleValue+1);
                }else{
                    map[foundName] = @1;
                }
                XCTAssertEqualObjects(dbLocation, found[0][@"ISO2"], @"%@", location);
            }else{
                failed ++;
                NSNumber * prev = mis[location];
                if( prev ){
                    mis[location] = @( prev.doubleValue+1);
                }else{
                    mis[location] = @1;
                }
            }
        }
    }
    if( failed ){
        NSLog( @"Failed %@/%@", @(failed),@(total) );
        NSLog(@"%@", mis);
    }
    NSLog(@"%@", map);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
