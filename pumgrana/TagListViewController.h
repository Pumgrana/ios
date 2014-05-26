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
#import "TagListProtocol.h"

@class ContentListViewController, ContentEditViewController;

@interface TagListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * Table element which display the tags.
 */
@property (weak, nonatomic) IBOutlet UITableView *tagListTable;

/**
 * The content list view the user is coming from.
 */
@property (nonatomic, strong) ContentListViewController *contentListView;

/**
 * The content edit view the user is coming from.
 */
@property (nonatomic, strong) ContentEditViewController *contentEditView;

/**
 * Generic used view
 */
@property (nonatomic, strong) NSObject<TagListProtocol> *usedView;

/**
 * All the tags.
 */
@property (nonatomic, strong) NSMutableArray *tags;

@end
