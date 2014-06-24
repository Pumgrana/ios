//
//  ContentEditViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 07/04/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"
#import "TagListViewController.h"

@class TagListViewController;

@interface ContentEditViewController : UIViewController

/**
 * Send button in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *sendButton;

/**
 * Represents the text field for the title of the content
 */
@property (weak, nonatomic) IBOutlet UITextField *titleField;

/**
 * Represents the text field for the description of the content
 */
@property (weak, nonatomic) IBOutlet UITextView *contentField;





/**
 * Tag list selection view
 */
@property (nonatomic, strong) TagListViewController *tagListView;





/**
 * All the tags.
 */
@property (nonatomic, strong) NSMutableArray *allTags;

/**
 * The tags filtered by the user.
 */
@property (nonatomic, strong) NSMutableArray *filteredTags;

/**
 * The content to edit.
 */
@property (nonatomic, strong) Content *content;

/**
 * Title to be displayed
 */
@property (nonatomic, strong) NSString *currentTitle;

/**
 * Description to be displayed
 */
@property (nonatomic, strong) NSString *currentDescription;





/**
 * When pushing the send button.
 */
- (IBAction)buttonSendPush:(id)sender;

/**
 * When the tags button is pushed.
 */
- (IBAction)buttonTagsPush:(id)sender;

@end
