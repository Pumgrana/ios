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

- (id)initWithTitle: (NSString *)t description:(NSString *)d tags:(NSMutableArray *)ta links:(NSMutableArray *)lks
{
    self.title = t;
    self.description = d;
    self.tags = ta;
    self.links = lks;
    return self;
}

- (BOOL)hasTag: (NSString *)tag
{
    for (Tag *t in self.tags) {
        if (tag == t.label)
            return YES;
    }
    
    return NO;
}

@end
