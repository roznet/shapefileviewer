//
//  VisitedCountriesTests.m
//  VisitedCountriesTests
//
//  Created by Brice Rosenzweig on 16/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RZUtils/RZUtils.h"
#import "VCShapeSetOrganizer.h"
#import "RZShapeFile.h"
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

-(NSIndexSet*)myCountrySelectionLong:(BOOL)a inSelection:(VCShapeSetSelection*)selection{
    NSArray * countries = a ?
    
     @[ @"CHINA", @"UNITED KINGDOM", @"UNITED STATES", @"FRANCE", @"AUSTRALIA",
     @"JAPAN", @"GERMANY", @"SWITZERLAND", @"MOROCCO",@"TUNISIA", @"NEW ZEALAND",
     @"MEXICO", @"SPAIN", @"CZECH", @"CANADA", @"ITALY", @"BELGIUM", @"KOREA, REP",
     @"VIET NAM",
     @"MALAYSIA", @"INDONESIA", @"THAILAND", @"PHILIPPINES", @"NETHERLAND", @"TURKEY"]
    
    :
    @[ @"CHINA", @"UNITED KINGDOM", @"UNITED STATES", @"FRANCE", @"AUSTRALIA",
       @"MALAYSIA", @"INDONESIA", @"THAILAND", @"PHILIPPINES", @"RUSSIA", @"KENYA"];
    /**/
    
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

-(NSIndexSet*)myFranceSelectionLong:(BOOL)a inSelection:(VCShapeSetSelection*)selection{
    NSArray * countries = a ?
    
    @[ @"Alsace", @"Corse"]
    
    :
    @[ @"Alsace", @"Corse", @"Champagne", @"Lorraine", @"Aquitaine"];
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
    
    [organizer newSelectionName:@"Test" withDefinitionName:@"Countries"];
    NSIndexSet * sel = [self myCountrySelectionLong:true inSelection:organizer.setSelection];
    [organizer setIndexSetForSelection:sel];
    NSUInteger count = organizer.setSelection.selection.count;
    
    [organizer newSelectionName:@"Test2" withDefinitionName:@"Countries"];
    sel = [self myCountrySelectionLong:false inSelection:organizer.setSelection];
    [organizer setIndexSetForSelection:sel];
    NSUInteger count2 = organizer.setSelection.selection.count;
    XCTAssertNotEqual(count2, count);

    [organizer loadSelectionName:@"Test" withDefinitionName:@"Countries"];
    XCTAssertEqual(count, organizer.setSelection.selection.count);
    
    [organizer newSelectionName:@"Test" withDefinitionName:@"France"];
    sel = [self myFranceSelectionLong:false inSelection:organizer.setSelection];
    [organizer setIndexSetForSelection:sel];
    NSUInteger count3 = organizer.setSelection.selection.count;
    
    [organizer loadSelectionName:@"Test" withDefinitionName:@"Countries"];
    XCTAssertEqual(count, organizer.setSelection.selection.count);
    
    [organizer loadSelectionName:@"Test" withDefinitionName:@"France"];
    XCTAssertEqual(count3, organizer.setSelection.selection.count);

    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
