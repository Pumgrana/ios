//
//  Content.h
//  pumgrana
//
//  Created by Romain Pichot on 17/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Content : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;

/**
 * Array containing Tag objects.
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 * Array containing Content objects.
 */
@property (nonatomic, strong) NSMutableArray *links;

- (id)initWithTitle:(NSString *)t description:(NSString *)d tags:(NSMutableArray *)ta links:(NSMutableArray *)lks;
- (id)initFromJson:(NSDictionary *)json;
- (BOOL)hasTag: (NSString *)tag;

@end
