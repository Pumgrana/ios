//
//  ContentTestCase.m
//  pumgrana
//
//  Created by Romain Pichot on 28/04/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Content.h"
#import "Tag.h"

@interface ContentTestCase : XCTestCase

@end

@implementation ContentTestCase

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

- (void)testTagExists
{
    Tag             *tag1 = [[Tag alloc] initWithLabel:@"Tag 1"];
    NSMutableArray  *tags = [[NSMutableArray alloc] initWithObjects:tag1, nil];
    NSMutableArray  *links = [[NSMutableArray alloc] init];
    Content         *c = [[Content alloc] initWithTitle:@"Test Content" description:@"Lorem Ipsum Dolor Sit Amet" tags:tags links:links];
    
    XCTAssertEqual([c hasTag:@"Tag 1"], YES, @"Should have found the tag");
}

- (void)testTagMissing
{
    NSMutableArray  *tags = [[NSMutableArray alloc] init];
    NSMutableArray  *links = [[NSMutableArray alloc] init];
    Content         *c = [[Content alloc] initWithTitle:@"Test Content" description:@"Lorem Ipsum Dolor Sit Amet" tags:tags links:links];
    
    XCTAssertEqual([c hasTag:@"Tag 1"], NO, @"Shouldn't have found the tag");
}

@end
