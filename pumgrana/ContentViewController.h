//
//  ContentViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 13/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTagListViewController.h"
#import "ContentEditViewController.h"

@class ContentListViewController, ContentEditViewController;

@interface ContentViewController : UIViewController

/**
 * Edit button in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *editButton;

/**
 * Label containing the title of the content.
 */
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;

/**
 * Text area containing the description of the content.
 */
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

/**
 * The view to be used to edit the content.
 */
@property (nonatomic, strong) ContentEditViewController *contentEditView;

/**
 * The view to be used to display the links of the content.
 */
@property (nonatomic, strong) ContentListViewController *contentListView;

/**
 * The view to be used to display the tags of the content.
 */
@property (nonatomic, strong) ContentTagListViewController *contentTagListView;

/**
 * The content to display.
 */
@property (nonatomic, strong) Content *content;

/**
 * When pushing the edit button.
 */
- (IBAction)buttonEditPush:(id)sender;

/**
 * When pushing the tags button.
 */
- (IBAction)buttonTagsPush:(id)sender;

/**
 * When pushing the links button.
 */
- (IBAction)buttonLinksPush:(id)sender;

@end
