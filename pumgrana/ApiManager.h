//
//  ApiManager.h
//  pumgrana
//
//  Created by Romain Pichot on 09/02/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"

//#define API_URL (@"http://163.5.84.222/api")
//#define API_URL (@"http://pichot.fr:1337")
#define API_URL (@"http://192.168.84.142:8081/api")

@interface ApiManager : NSObject

+ (BOOL)checkResponseStatus:(NSDictionary *)response;
+ (id)getJSONResponse:(NSString *)urlParams;

+ (NSMutableArray *)getContents;
+ (Content *)getContentWithId:(NSString *)id;
+ (NSMutableArray *)getTagsWithType:(NSString *)type;
+ (NSMutableArray *)getContentLinks:(Content *)content;
+ (NSMutableArray *)getContentTags:(Content *)content;
+ (NSMutableArray *)getTagsFromContentLinks:(Content *)content;
+ (NSMutableArray *)getContentsFilteredByTags:(NSMutableArray *)tags;
+ (NSMutableArray *)getLinksFilteredByTags:(NSMutableArray *)tags content:(Content *)content;

+ (void)updateContent:(Content *)content;
+ (NSString *)insertContent:(Content *)content;
+ (void)deleteContents:(NSMutableArray *)contents;
+ (void)insertLink:(Link *)link content:(Content *)content;
+ (void)deleteLinks:(NSMutableArray *)links;

@end
