//
//  ContentListViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 13/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "AppDelegate.h"
#import "TagListViewController.h"

@class TagListViewController, ContentViewController;

@interface ContentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * Label with the list of the filtered tags.
 */
@property (weak, nonatomic) IBOutlet UILabel *tagListLabel;

/**
 * Table to display the contents in.
 */
@property (nonatomic, strong) IBOutlet UITableView *contentTableView;





/**
 * Linked content (if it exists)
 */
@property (nonatomic, strong) Content *content;

/**
 * The contents to display.
 */
@property (nonatomic, strong) NSMutableArray *contentsToShow;

/**
 * All the tags.
 */
@property (nonatomic, strong) NSMutableArray *allTags;

/**
 * The tags filtered by the user.
 */
@property (nonatomic, strong) NSMutableArray *filteredTags;





/**
 * The view to display the content the user has chosen.
 */
@property (nonatomic, strong) ContentViewController *contentView;

/**
 * The view for the tag filtering page.
 */
@property (nonatomic, strong) TagListViewController *tagListView;





- (IBAction)buttonTagPush:(id)sender;




- (void)updateTagListLabel;

@end
