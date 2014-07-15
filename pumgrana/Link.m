//
//  Link.m
//  pumgrana
//
//  Created by Romain Pichot on 24/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import "Link.h"

@implementation Link

/**
 * Constructor based on a link serialized in JSON coming from the response of the API
 * @param json A JSON link deserialized as a dictionary
 * @return The new link
 */
- (id)initFromJson:(NSDictionary *)json
{
    self.uri = [json objectForKey:@"link_uri"];
    self.contentUri = [json objectForKey:@"content_uri"];
    self.contentTitle = [json objectForKey:@"content_title"];
    self.contentSummary = [json objectForKey:@"content_summary"];
    self.tags = [[NSMutableArray alloc] init];
    
    return self;
}

/**
 * Construct from a content
 * @param content The content to copy
 * @return The new link
 */
- (id)initFromContent:(Content *)content
{
    self.uri = nil;
    self.contentUri = content.uri;
    self.contentTitle = content.title;
    self.contentSummary = content.summary;
    self.tags = [[NSMutableArray alloc] init];
    
    return self;
}





/**
 * Tests if it is equal to another link
 */
- (BOOL)isEqualToLink:(Link *)link
{
    return [self.uri isEqualToString:link.uri];
}





/**
 * Gets the uri of the linked content
 * @return The linked content's uri
 */
- (NSString *)getContentUri
{
    return self.contentUri;
}

/**
 * Gets the title of the linked content
 * @return The linked content's title
 */
- (NSString *)getContentTitle
{
    return self.contentTitle;
}

/**
 * Gets the summary of the linked content
 * @return The linked content's summary
 */
- (NSString *)getContentSummary
{
    return self.contentSummary;
}

@end
