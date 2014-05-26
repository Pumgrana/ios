//
//  TagListProtocol.h
//  pumgrana
//
//  Created by Romain Pichot on 07/04/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TagListProtocol <NSObject>

/**
 * All the tags.
 */
@property (nonatomic, strong) NSMutableArray *allTags;

/**
 * The tags filtered by the user.
 */
@property (nonatomic, strong) NSMutableArray *filteredTags;

@end
