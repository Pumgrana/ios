//
//  NSString+Encode.m
//  pumgrana
//
//  Created by Romain Pichot on 14/07/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

- (NSString *)encodeString:(NSStringEncoding)encoding
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@";/?:@&=$+{}<>,", CFStringConvertNSStringEncodingToEncoding(encoding)));
}

@end
