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


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
