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
 * Default constructor
 * @return The new content
 */
- (id)init
{
    self.uri = nil;
    self.title = [[NSString alloc] init];
    self.summary = [[NSString alloc] init];
    self.body = [[NSString alloc] init];
    self.tags = [[NSMutableArray alloc] init];
    self.links = [[NSMutableArray alloc] init];
    self.external = NO;
    
    return self;
}

/**
 * Constructor based on a content serialized in JSON coming from the response of the API
 * @param json A JSON content deserialized as a dictionary
 * @return The new content
 */
- (id)initFromJson:(NSDictionary *)json
{
    self.uri = [json objectForKey:@"uri"];
    
    self.title = [json objectForKey:@"title"];
    if (self.title == nil) self.title = [[NSString alloc] init];
    
    self.summary = [json objectForKey:@"summary"];
    if (self.summary == nil) self.summary = [[NSString alloc] init];
    
    self.body = [json objectForKey:@"body"];
    if (self.body == nil) self.body = [[NSString alloc] init];
    
    self.tags = [[NSMutableArray alloc] init];
    self.links = [[NSMutableArray alloc] init];
    
    NSNumber *jsonExternal = [json objectForKey:@"external"];
    if (jsonExternal == nil) self.external = YES;
    else self.external = [jsonExternal boolValue];
    
    return self;
}

/**
 * Copy constructor
 * @param content The content to copy
 * @return The new content
 */
- (id)initFromContent:(Content *)content
{
    self.uri = [[NSString alloc] initWithString:content.uri];
    self.title = [[NSString alloc] initWithString:content.title];
    self.summary = [[NSString alloc] initWithString:content.summary];
    self.body = [[NSString alloc] initWithString:content.body];
    self.tags = [[NSMutableArray alloc] initWithArray:content.tags];
    self.links = [[NSMutableArray alloc] initWithArray:content.links];
    self.external = content.external;
    
    return self;
}


/**
 * Tests if the content is equal to another
 * @param content The content to compare to
 * @return YES or NO whether the contents are the same or not
 */
- (BOOL)isEqualToContent: (Content *)content
{
    return [self.uri isEqualToString:content.uri];
}

/**
 * Tests if the content is equal to a link
 * @param link The link to compare to
 * @return YES if the link relates to this content
 */
- (BOOL)isEqualToLink:(Link *)link
{
    return [self.uri isEqualToString:link.contentUri];
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





/**
 * Gets the uri of the content
 * @return The content's uri
 */
- (NSString *)getContentUri
{
    return self.uri;
}

/**
 * Gets the title of the content
 * @return The content's title
 */
- (NSString *)getContentTitle
{
    return self.title;
}

/**
 * Gets the summary of the content
 * @return The content's summary
 */
- (NSString *)getContentSummary
{
    return self.summary;
}

@end
