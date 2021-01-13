//
//  shapeviewTests.m
//  shapeviewTests
//
//  Created by Brice Rosenzweig on 29/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
@import RZExternalUniversal;
@import RZUtils;
@import RZUtilsMacOS;
@import RZUtilsUniversal;

@interface shapeviewTests : XCTestCase

@end

@implementation shapeviewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(NSString*)commonBaseIn:(NSArray*)files forExtensions:(NSArray*)exts{
    if (files.count == exts.count) {
        NSString * base = nil;
        BOOL hasCommonBase = true;
        //NSMutableArray * hasExt = [NSMutableArray arrayWithCapacity:exts.count];
        
        for (NSString * one in files) {
            size_t i = 0;
            for (NSString * ext in exts) {
                if ([[one pathExtension] isEqualToString:ext]) {
                    //hasExt[i]=true;
                }
                i++;
            }
            if (base==nil) {
                base = [one stringByDeletingPathExtension];
            }else{
                if (![base isEqualToString:[one stringByDeletingPathExtension]]) {
                    hasCommonBase = false;
                }
            }
        }
        if (hasCommonBase ) {
            return base;
        }
    }
    return nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    
    NSColor * color = [NSColor purpleColor];
    NSUInteger rgb = 0xFF0000 * [color redComponent] + 0x00FF00 * [color greenComponent] + 0x0000FF * [color blueComponent];
    
    NSColor * back = [NSColor colorWithHexValue:rgb andAlpha:1.0];
    NSLog(@"%@ %@", color, back);

    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
