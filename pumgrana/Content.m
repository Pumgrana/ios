//
//  Content.m
//  pumgrana
//
//  Created by Romain Pichot on 17/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import "Content.h"
#import "Tag.h"

@implementation Content

/**
 * Constructor based on a content serialized in JSON coming from the response of the API
 * @param json A JSON content deserialized as a dictionary
 */
- (id)initFromJson:(NSDictionary *)json
{
    self.id = [json objectForKey:@"_id"];
    self.title = [json objectForKey:@"title"];
    self.summary = [json objectForKey:@"summary"];
    self.text = [json objectForKey:@"text"];
    self.tags = [[NSMutableArray alloc] init];
    self.links = [[NSMutableArray alloc] init];
    return self;
}

/**
 * Tests if the content has a given tag
 * @param tag The tag to search for
 * @return YES or NO whether the content has the tag or not
 */
- (BOOL)hasTag: (Tag *)tag
{
    for (Tag *t in self.tags) {
        if ([tag isEqualToTag:t])
            return YES;
    }
    
    return NO;
}

@end
