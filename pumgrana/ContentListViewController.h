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
#import "ContentEditViewController.h"

@class TagListViewController, ContentViewController, ContentEditViewController;

@interface ContentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>

/**
 * Button to add a content in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *addContentButton;

/**
 * Label with the list of the filtered tags
 */
@property (weak, nonatomic) IBOutlet UILabel *tagListLabel;

/**
 * Table to display the contents in
 */
@property (nonatomic, strong) IBOutlet UITableView *contentTableView;





/**
 * Linked content (if it exists)
 */
@property (nonatomic, strong) Content *content;

/**
 * The contents to display
 */
@property (nonatomic, strong) NSMutableArray *contentsToShow;

/**
 * All the tags
 */
@property (nonatomic, strong) NSMutableArray *allTags;

/**
 * The tags filtered by the user
 */
@property (nonatomic, strong) NSMutableArray *filteredTags;

/**
 * Data received asynchronously
 */
@property (nonatomic, strong) NSMutableData *receivedData;




/**
 * The view to create a new content
 */
@property (nonatomic, strong) ContentEditViewController *contentEditView;

/**
 * The view to display the content the user has chosen.
 */
@property (nonatomic, strong) ContentViewController *contentView;

/**
 * The view for the tag filtering page.
 */
@property (nonatomic, strong) TagListViewController *tagListView;





- (IBAction)buttonAddContentPush:(id)sender;
- (IBAction)buttonTagPush:(id)sender;





- (void)updateTagListLabel;

@end
