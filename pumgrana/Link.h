//
//  Link.h
//  pumgrana
//
//  Created by Romain Pichot on 24/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartialContentProtocol.h"

@interface Link : NSObject <PartialContentProtocol>

@property (nonatomic, strong) NSString  *id;
@property (nonatomic, strong) NSString  *contentId;
@property (nonatomic, strong) NSString  *contentTitle;
@property (nonatomic, strong) NSString  *contentSummary;

- (id)initFromJson:(NSDictionary *)json;

@end
