//
//  ApiManagerTestCase.m
//  pumgrana
//
//  Created by Romain Pichot on 28/04/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ApiManager.h"

@interface ApiManagerTestCase : XCTestCase

@end

@implementation ApiManagerTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testGetAllContents
{
    NSMutableArray  *contents = [ApiManager getContents];
    
    XCTAssertNotEqual([contents count], 0, @"No contents found");
}

@end
