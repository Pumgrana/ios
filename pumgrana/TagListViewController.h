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
#import "EditTagViewController.h"

@class ContentListViewController, ContentEditViewController;

@interface TagListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

/**
 * Popup displayed when user wants to delete a tag
 */
@property (nonatomic, strong) UIAlertView *tagDeleteAlert;

/**
 * Button to delete a tag in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *deleteTagButton;

/**
 * Button to add a tag in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *addTagButton;

/**
 * Table element which display the tags.
 */
@property (weak, nonatomic) IBOutlet UITableView *tagListTable;





/**
 * The view to create a new tag
 */
@property (nonatomic, strong) EditTagViewController *editTagView;





/**
 * All the tags.
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 * Already selected tags.
 */
@property (nonatomic, strong) NSMutableArray *selectedTags;

/**
 * Deleting mode or not
 */
@property BOOL isDeleting;

/**
 * Selected tag to delete
 */
@property Tag *selectedTag;

/**
 * Type of the tags
 */
@property (nonatomic, strong) NSString *type;





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)buttonDeleteTagPush:(id)sender;
- (IBAction)buttonAddTagPush:(id)sender;
- (void)rowSwitchChanged:(id)sender;





- (void)loadDataWithTags:(NSMutableArray *)tags selectedTags:(NSMutableArray *)selectedTags type:(NSString *)type;
- (void)toggleDeleteMode;

@end
