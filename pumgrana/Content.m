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
 * Default raw constructor. Not used.
 */
- (id)initWithTitle: (NSString *)t description:(NSString *)d tags:(NSMutableArray *)ta links:(NSMutableArray *)lks
{
    self.id = @1;
    self.title = t;
    self.description = d;
    self.tags = ta;
    self.links = lks;
    return self;
}

/**
 * Constructor based on a content serialized in JSON coming from the response of the API.
 */
- (id)initFromJson:(NSDictionary *)json
{
    self.id = [json objectForKey:@"_id"];
    self.title = [json objectForKey:@"title"];
    self.description = [json objectForKey:@"text"];
    return self;
}

/**
 * Returns YES if the content has the specified tag with its name in parameter.
 */
- (BOOL)hasTag: (NSString *)tag
{
    for (Tag *t in self.tags) {
        if (tag == t.label)
            return YES;
    }
    
    return NO;
}

@end
