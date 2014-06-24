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
 */
- (id)initFromJson:(NSDictionary *)json
{
    self.id = [json objectForKey:@"link_id"];
    self.contentId = [json objectForKey:@"content_id"];
    self.contentTitle = [json objectForKey:@"content_title"];
    self.contentSummary = [json objectForKey:@"content_summary"];
    
    return self;
}





/**
 * Gets the id of the linked content
 * @return The linked content's id
 */
- (NSString *)getContentId
{
    return self.contentId;
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
