//
//  ContentEditLinkTagsViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 27/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "Link.h"
#import "Content.h"
#import "EditTagViewController.h"

@interface ContentEditLinkTagsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

/**
 * Popup displayed when user wants to delete a tag
 */
@property (nonatomic, strong) UIAlertView *tagDeleteAlert;

/**
 * Button to show the possible actions in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *actionButton;

/**
 * Action sheet (popup with different actions)
 */
@property (nonatomic, strong) UIActionSheet *actionSheet;

/**
 * Popup to show when an error occurs
 */
@property (nonatomic, strong) UIAlertView *errorAlert;

/**
 * Done button in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *doneButton;

/**
 * Table to display the tags in
 */
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;





/**
 * The view to create a new tag
 */
@property (nonatomic, strong) EditTagViewController *editTagView;





/**
 * The link to edit
 */
@property (nonatomic, strong) Link *link;

/**
 * The content owning the link to edit
 */
@property (nonatomic, strong) Content *content;

/**
 * Tags to be displayed
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 * User wants to delete tags
 */
@property BOOL isDeleting;

/**
 * Selected tag to delete
 */
@property Tag *selectedTag;






- (IBAction)buttonDonePush:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)rowSwitchChanged:(id)sender;




- (void)editLink:(Link *)link content:(Content *)content;

@end
