//
//  ApiManager.m
//  pumgrana
//
//  Created by Romain Pichot on 09/02/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import "ApiManager.h"
#import "Content.h"
#import "Tag.h"
#import "Link.h"

@implementation ApiManager

/**
 * Checks if there are no error with the response
 * @param response Entire response from the API request
 * @return YES if everything is ok
 */
+ (BOOL)checkResponseStatus:(NSDictionary *)response
{
    NSNumber    *status = [response objectForKey:@"status"];

    return ([status isEqual:@200] || [status isEqual:@201] || [status isEqual:@204]);
}

/**
 * Makes a request to the API
 * @todo asynchronous request
 * @todo refresh calls
 * @todo persistance (local db)
 * @param urlParams Parameters for the API url
 * @return The response or nil if it fails
 */
+ (id)getJSONResponse:(NSString *)urlParams
{
    NSString    *urlStr     = API_URL;
    NSURL       *url        = [NSURL URLWithString:[urlStr stringByAppendingString:urlParams]];
    NSError     *urlError   = nil;
    NSData      *data       = [NSData dataWithContentsOfURL:url options:0 error:&urlError];
    
    if (data) {
        NSError     *error      = nil;
        id          response    = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ([ApiManager checkResponseStatus:response])
            return (response);
    }
    
    return (nil);
}

/**
 * Makes an API call to get all the contents
 * @return An array of Content objects
 */
+ (NSMutableArray *)getContents
{
    NSDictionary    *response   = [ApiManager getJSONResponse:@"/content/list_content/"];
    NSMutableArray  *ret        = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *contents   = [response objectForKey:@"contents"];
        
        for (NSDictionary *content in contents) {
            Content *c = [[Content alloc] initFromJson:content];
            [ret addObject:c];
        }
    }
    
    return (ret);
}

/**
 * Gets a full detailed content via the API
 * @param id The id of the content we want
 * @return The content we want
 */
+ (Content *)getContentWithId:(NSString *)id
{
    NSString        *url        = [[NSString alloc] initWithFormat:@"/content/detail/%@", id];
    NSDictionary    *response   = [ApiManager getJSONResponse:url];
    Content         *content    = [[Content alloc] init];
    
    content.id = id;
    
    if (response) {
        NSArray *contentArray = [response objectForKey:@"contents"];
        
        if (![contentArray isEqual:[NSNull null]] && [contentArray count] > 0)
            content = [[Content alloc] initFromJson:[contentArray objectAtIndex:0]];
    }
    
    return content;
}

/**
 * Makes an API call to get all the tags
 * @return An array of Tag objects
 */
+ (NSMutableArray *)getTagsWithType:(NSString *)type
{
    NSDictionary    *response   = [ApiManager getJSONResponse:[[NSString alloc] initWithFormat:@"/tag/list_by_type/%@", type]];
    NSMutableArray  *ret        = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *tags   = [response objectForKey:@"tags"];
        
        for (NSDictionary *tag in tags) {
            Tag *t = [[Tag alloc] initFromJson:tag];
            [ret addObject:t];
        }
    }
    
    return (ret);
}

/**
 * Gets the links of a content via the API
 * @param content The content we want the links
 * @return The list of links
 */
+ (NSMutableArray *)getContentLinks:(Content *)content
{
    NSString        *url        = @"/link/list_from_content/";
    NSDictionary    *response   = [ApiManager getJSONResponse:[url stringByAppendingFormat:@"%@", content.id]];
    NSMutableArray  *links      = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *linkArray  = [response objectForKey:@"links"];
        
        if (![linkArray isEqual:[NSNull null]]) {
            for (NSDictionary *link in linkArray) {
                Link *newLink = [[Link alloc] initFromJson:link];
                [links addObject:newLink];
            }
        }
    }
    
    return links;
}

/**
 * Returns the tag list of a content
 * @param content The content we want the tags
 * @return Content's tag list
 */
+ (NSMutableArray *)getContentTags:(Content *)content
{
    NSString        *url        = @"/tag/list_from_content/";
    NSDictionary    *response   = [ApiManager getJSONResponse:[url stringByAppendingFormat:@"%@", content.id]];
    NSMutableArray  *tags       = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *tagArray  = [response objectForKey:@"tags"];
        
        for (NSDictionary *tag in tagArray) {
            Tag *newTag = [[Tag alloc] initFromJson:tag];
            [tags addObject:newTag];
        }
    }
    
    return (tags);
}

/**
 * Gets the list of tags corresponding to all the tags contained in the content links
 * @param content The content we want the link tags from
 * @return The list of tags related to the links
 */
+ (NSMutableArray *)getTagsFromContentLinks:(Content *)content
{
    NSString        *url        = @"/tag/list_from_content_links/";
    NSDictionary    *response   = [ApiManager getJSONResponse:[url stringByAppendingString:content.id]];
    NSMutableArray  *linkTags   = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *linkTagArray = [response objectForKey:@"tags"];
        
        if (![linkTagArray isEqual:[NSNull null]]) {
            for (NSDictionary *tag in linkTagArray) {
                Tag *newTag = [[Tag alloc] initFromJson:tag];
                [linkTags addObject:newTag];
            }
        }
    }
    
    return linkTags;
}

/**
 * Get only contents containing one of the given tags
 * @param tags The tags used to filter the contents
 * @return The list of filtered contents
 */
+ (NSMutableArray *)getContentsFilteredByTags:(NSMutableArray *)tags
{
    NSMutableString *paramTags  = [[NSMutableString alloc] init];
    for (Tag *tag in tags) {
        [paramTags appendFormat:@"%@/", tag.id];
    }
    
    NSString        *url        = [[NSString alloc] initWithFormat:@"/content/list_content//%@", paramTags];
    NSDictionary    *response   = [ApiManager getJSONResponse:url];
    NSMutableArray  *contents   = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *contentArray = [response objectForKey:@"contents"];
        
        if (![contentArray isEqual:[NSNull null]]) {
            for (NSDictionary *content in contentArray) {
                Content *newContent = [[Content alloc] initFromJson:content];
                [contents addObject:newContent];
            }
        }
    }
    
    return contents;
}

/**
 * Get only links of the content containing one of the given tags
 * @param tags The tags used to filter the links
 * @param content The content we want to filter the links from
 * @return The list of filtered links
 */
+ (NSMutableArray *)getLinksFilteredByTags:(NSMutableArray *)tags content:(Content *)content
{
    NSMutableString *paramTags  = [[NSMutableString alloc] init];
    for (Tag *tag in tags) {
        [paramTags appendFormat:@"%@/", tag.id];
    }
    
    NSString        *url        = [[NSString alloc] initWithFormat:@"/link/list_from_content_tags/%@/%@", content.id, paramTags];
    NSDictionary    *response   = [ApiManager getJSONResponse:url];
    NSMutableArray  *links      = [[NSMutableArray alloc] init];
    
    if (response) {
        NSArray *linkArray = [response objectForKey:@"links"];
        
        if (![linkArray isEqual:[NSNull null]]) {
            for (NSDictionary *link in linkArray) {
                Link *newLink = [[Link alloc] initFromJson:link];
                [links addObject:newLink];
            }
        }
    }
    
    return links;
}





/**
 * Updates a content
 * @param content The content to update
 */
+ (void)updateContent:(Content *)content
{
    NSMutableString *paramTags  = [[NSMutableString alloc] initWithString:@"["];
    NSInteger       index       = 0;
    for (Tag *t in content.tags) {
        if (index > 0)
            [paramTags appendString:@","];
        [paramTags appendFormat:@"\"%@\"", t.id];
        ++index;
    }
    [paramTags appendString:@"]"];
    
    NSString    *params     = [[NSString alloc] initWithFormat:@"{\"content_id\":\"%@\",\"title\":\"%@\", \"summary\":\"%@\",\"text\":\"%@\",\"tags_id\":%@}", content.id, content.title, content.summary, content.text, paramTags];
    NSData      *postData   = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSString    *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString    *baseUrl    = API_URL;
    NSString    *url        = [baseUrl stringByAppendingString:@"/content/update"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

/**
 * Creates a new content
 * @param content The content to create
 */
+ (void)insertContent:(Content *)content
{
    NSMutableString *paramTags  = [[NSMutableString alloc] initWithString:@"["];
    NSInteger       index       = 0;
    for (Tag *t in content.tags) {
        if (index > 0)
            [paramTags appendString:@","];
        [paramTags appendFormat:@"\"%@\"", t.id];
        ++index;
    }
    [paramTags appendString:@"]"];
    
    NSString    *params     = [[NSString alloc] initWithFormat:@"{\"title\":\"%@\", \"summary\":\"%@\", \"text\":\"%@\", \"tags_id\":%@}", content.title, content.summary, content.text, paramTags];
    NSData      *postData   = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSString    *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString    *baseUrl    = API_URL;
    NSString    *url        = [baseUrl stringByAppendingString:@"/content/insert"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

/**
 * Deletes the given contents
 * @param contents The contents to delete
 */
+ (void)deleteContents:(NSMutableArray *)contents
{
    NSMutableString *params = [[NSMutableString alloc] initWithFormat:@"{\"contents_id\":["];
    NSInteger       index   = 0;
    for (Content *content in contents) {
        if (index > 0)
            [params appendString:@","];
        [params appendFormat:@"\"%@\"", content.id];
        ++index;
    }
    [params appendString:@"]}"];
    
    NSData      *postData   = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSString    *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString    *url        = [[NSString alloc] initWithFormat:@"%@/content/delete", API_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse   *response;
    NSError         *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

/**
 * Insert a link in a content
 * @param link The link to insert
 * @param content The content meant to own the link
 */
+ (void)insertLink:(Link *)link content:(Content *)content
{
    NSMutableString *params = [[NSMutableString alloc] initWithFormat:@"{\"id_from\":\"%@\", \"ids_to\":[\"%@\"], \"tags_id\":[[", content.id, link.contentId];
    NSInteger       index = 0;
    for (Tag *tag in link.tags) {
        if (index > 0)
            [params appendString:@","];
        [params appendFormat:@"\"%@\"", tag.id];
        ++index;
    }
    [params appendString:@"]]}"];
    
    NSData      *postData   = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSString    *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString    *url        = [[NSString alloc] initWithFormat:@"%@/link/insert", API_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse   *response;
    NSError         *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

/**
 * Delete links
 * @param links The list of links to content
 */
+ (void)deleteLinks:(NSMutableArray *)links
{
    NSMutableString *params = [[NSMutableString alloc] initWithString:@"{\"links_id\":["];
    NSInteger       index = 0;
    for (Link *link in links) {
        if (index > 0)
            [params appendString:@","];
        [params appendFormat:@"\"%@\"", link.id];
        ++index;
    }
    [params appendString:@"]}"];
    
    NSData      *postData   = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSString    *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSString    *url        = [[NSString alloc] initWithFormat:@"%@/link/delete", API_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse   *response;
    NSError         *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

@end
