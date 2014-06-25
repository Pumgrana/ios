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

@interface ContentEditViewController : UIViewController <UIAlertViewDelegate>

/**
 * Popup displayed when editing is sucessful
 */
@property (nonatomic, strong) UIAlertView *editAlert;

/**
 * Send button in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *doneButton;

/**
 * Represents the text field for the title of the content
 */
@property (weak, nonatomic) IBOutlet UITextField *titleField;

/**
 * Represents the text field for the summary of the content
 */
@property (weak, nonatomic) IBOutlet UITextField *summaryField;

/**
 * Represents the text field for the text of the content
 */
@property (weak, nonatomic) IBOutlet UITextView *textField;





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
//@property (nonatomic, strong) NSMutableArray *filteredTags;

/**
 * The content to edit.
 */
//@property (nonatomic, strong) Content *content;

/**
 * Temporary content to be sent to the server
 */
@property (nonatomic, strong) Content *temporaryContent;

/**
 * Title to be displayed
 */
//@property (nonatomic, strong) NSString *currentTitle;

/**
 * Description to be displayed
 */
//@property (nonatomic, strong) NSString *currentDescription;





- (IBAction)buttonDonePush:(id)sender;
- (IBAction)buttonTagsPush:(id)sender;





- (void)loadContent:(Content *)content;

@end
