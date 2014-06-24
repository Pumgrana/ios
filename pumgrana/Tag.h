//
//  Tag.h
//  pumgrana
//
//  Created by Romain Pichot on 18/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *subject;

- (id)initWithLabel:(NSString *)l;
- (id)initFromJson:(NSDictionary *)json;

- (BOOL)isEqualToTag:(Tag *)tag;

@end
