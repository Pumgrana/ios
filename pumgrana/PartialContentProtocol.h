//
//  PartialContentProtocol.h
//  pumgrana
//
//  Created by Romain Pichot on 24/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PartialContentProtocol <NSObject>

- (NSString *)getContentId;
- (NSString *)getContentTitle;
- (NSString *)getContentSummary;

@end
