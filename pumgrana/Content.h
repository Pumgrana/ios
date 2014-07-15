//
//  Content.h
//  pumgrana
//
//  Created by Romain Pichot on 17/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"
#import "PartialContentProtocol.h"
#import "Link.h"

@class Link;

@interface Content : NSObject <PartialContentProtocol>

@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *links;
@property BOOL external;





- (id)init;
- (id)initFromJson:(NSDictionary *)json;
- (id)initFromContent:(Content *)content;

- (BOOL)isEqualToContent:(Content *)content;
- (BOOL)isEqualToLink:(Link *)link;
- (BOOL)hasTag:(Tag *)tag;

@end
