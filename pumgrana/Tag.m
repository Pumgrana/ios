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
 * Constructor based on a tag serialized in JSON coming from the response of the API
 * @param json A JSON tag deserialized as a dictionary
 */
- (id)initFromJson:(NSDictionary *)json
{
    self.id = [json objectForKey:@"_id"];
    self.subject = [json objectForKey:@"subject"];
    return self;
}

/**
 * Comparing to another tag
 * @param tag The tag to compare to
 * @return YES if the two tags are equal
 */
- (BOOL)isEqualToTag:(Tag *)tag
{
    return [self.id isEqualToString:tag.id];
}

@end
