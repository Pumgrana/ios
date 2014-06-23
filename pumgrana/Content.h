//
//  Content.h
//  pumgrana
//
//  Created by Romain Pichot on 17/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"

@interface Content : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *text;

/**
 * Array containing Tag objects.
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 * Array containing Content objects.
 */
@property (nonatomic, strong) NSMutableArray *links;





- (id)initFromJson:(NSDictionary *)json;
- (BOOL)hasTag: (Tag *)tag;

@end
