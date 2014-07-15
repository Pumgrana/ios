//
//  Link.h
//  pumgrana
//
//  Created by Romain Pichot on 24/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartialContentProtocol.h"
#import "Content.h"

@class Content;

@interface Link : NSObject <PartialContentProtocol>

@property (nonatomic, strong) NSString  *uri;
@property (nonatomic, strong) NSString  *contentUri;
@property (nonatomic, strong) NSString  *contentTitle;
@property (nonatomic, strong) NSString  *contentSummary;

@property (nonatomic, strong) NSMutableArray *tags;





- (id)initFromJson:(NSDictionary *)json;
- (id)initFromContent:(Content *)content;

- (BOOL)isEqualToLink:(Link *)link;

@end
