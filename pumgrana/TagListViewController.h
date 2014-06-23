//
//  TagListViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 22/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentListViewController.h"
#import "ContentEditViewController.h"

@class ContentListViewController, ContentEditViewController;

@interface TagListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * Table element which display the tags.
 */
@property (weak, nonatomic) IBOutlet UITableView *tagListTable;





/**
 * All the tags.
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 * Already selected tags.
 */
@property (nonatomic, strong) NSMutableArray *selectedTags;





- (void)loadDataWithTags:(NSMutableArray *)tags selectedTags:(NSMutableArray *)selectedTags;

@end
