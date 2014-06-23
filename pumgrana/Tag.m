//
//  Tag.m
//  pumgrana
//
//  Created by Romain Pichot on 18/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import "Tag.h"

@implementation Tag

/**
 * Default raw constructor. Not used.
 */
- (id)initWithLabel:(NSString *)l
{
    self.id = @"1";
    self.label = l;
    return self;
}

/**
 * Constructor based on a tag serialized in JSON coming from the response of the API.
 */
- (id)initFromJson:(NSDictionary *)json
{
    self.id = [json objectForKey:@"_id"];
    self.label = [json objectForKey:@"subject"];
    return self;
}

- (BOOL)isEqualToTag:(Tag *)tag
{
    return [self.id isEqualToString:tag.id];
}

@end
