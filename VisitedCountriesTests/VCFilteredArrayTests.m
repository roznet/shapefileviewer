//
//  VCFilteredArrayTests.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 22/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RZUtils/RZUtils.h"

@interface VCFilteredArrayTests : XCTestCase

@end

@implementation VCFilteredArrayTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFilteredArray {
    NSArray * base = @[ @"a1", @"a2", @"a3", @"b1", @"b2", @"c3"];
    RZFilteredSelectedArray * fa = [RZFilteredSelectedArray array:base withFilter:^(NSString * s) {
        return [s containsString:@"2"];
    }];
    for (NSString * one in fa) {
        XCTAssertTrue([one containsString:@"2"]);
    }
    XCTAssertEqual(fa.count, 2);
    XCTAssertEqual(@"a2", fa[0]);
    XCTAssertEqual(@"b2", fa[1]);
    
    fa.filter = ^(NSString*s){
        return [s containsString:@"3"];
    };
    
    for (NSString * one in fa) {
        XCTAssertTrue([one containsString:@"3"]);
    }
    XCTAssertEqual(fa.count, 2);
    XCTAssertEqual(@"a3", fa[0]);
    XCTAssertEqual(@"c3", fa[1]);
    
    // Start with Empty Selection
    // select index 0
    [fa selectionAddIndex:0];
    NSArray * se = [fa selectedArray];
    // check one global object selected
    XCTAssertEqual(se.count, 1);
    XCTAssertEqualObjects(fa[0], se[0]);

    // remove selection in filtered.
    [fa selectionRemoveIndex:0];
    se = [fa selectedArray];
    // check no global selection
    XCTAssertEqual(se.count, 0);

    // select both filtered object
    [fa selectionAddIndex:0];
    [fa selectionAddIndex:1];
    se = [fa selectedArray];
    // check global selection is 2 and correct
    XCTAssertEqual(se.count, 2);
    XCTAssertEqualObjects(fa[0], se[0]);
    XCTAssertEqualObjects(fa[1], se[1]);
    
    // Change filter
    fa.filter = ^(NSString * s){
        return [s hasPrefix: @"a"];
    };
    // check global selection didn't change still 2
    se = [fa selectedArray];
    XCTAssertEqual(se.count, 2);
    
    // check filtered selection is only 1
    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 1);
    XCTAssertEqualObjects(se[0], @"a3");
    
    // ======== Now start a new filtered array with selection already
    fa = [RZFilteredSelectedArray array:base withFilter:^(NSString * s) {
        return [s containsString:@"2"];
    }];
    NSIndexSet * si = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 3)];
    fa.selectionIndexes = si;
    se = [fa selectedArray];
    XCTAssertEqual(se.count, 3);

    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 1);
    XCTAssertEqualObjects(se[0], @"a2");
    
    // Change filter
    fa.filter = ^(NSString * s){
        return [s hasPrefix: @"a"];
    };
    
    // check filtered selection is only 1
    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 3);
    XCTAssertEqualObjects(se[0], @"a1");
    XCTAssertEqualObjects(se[1], @"a2");

    // Change filter
    fa.filter = ^(NSString * s){
        return [s hasPrefix: @"b"];
    };
    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 0);
    
    // -- Now test after removing filter
    fa.filter = nil;
    se = [fa selectedArray];
    XCTAssertEqual(se.count, 3);
    
    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 3);
    
    [fa selectionRemoveIndex:1];
    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 2);
    se = [fa selectedArray];
    XCTAssertEqual(se.count, 2);
    XCTAssertEqualObjects(se[0], @"a1");
    XCTAssertEqualObjects(se[1], @"a3");
    
    // ======== Now start a new unfiltered array with selection
    fa = [RZFilteredSelectedArray array:base withFilter:nil];
    si = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 3)];
    fa.selectionIndexes = si;
    se = [fa selectedArray];
    XCTAssertEqual(se.count, 3);
    
    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 3);
    
    [fa selectionRemoveIndex:1];
    se = [fa filteredSelectedArray];
    XCTAssertEqual(se.count, 2);
    se = [fa selectedArray];
    XCTAssertEqual(se.count, 2);
    XCTAssertEqualObjects(se[0], @"a1");
    XCTAssertEqualObjects(se[1], @"a3");

    
    

    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
