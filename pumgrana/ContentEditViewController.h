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
#import "ContentEditLinksViewController.h"

@class TagListViewController;

@interface ContentEditViewController : UIViewController <UIAlertViewDelegate>

/**
 * Popup displayed when editing is sucessful
 */
@property (nonatomic, strong) UIAlertView *editAlert;

/**
 * Done button in navigation bar
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
 * Links edit view
 */
@property (nonatomic, strong) ContentEditLinksViewController *contentEditLinksView;





/**
 * All the tags.
 */
@property (nonatomic, strong) NSMutableArray *allTags;

/**
 * Original list of links
 */
@property (nonatomic, strong) NSMutableArray *savedLinks;

/**
 * Temporary content to be sent to the server
 */
@property (nonatomic, strong) Content *temporaryContent;





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)buttonDonePush:(id)sender;
- (IBAction)buttonTagsPush:(id)sender;
- (IBAction)buttonLinksPush:(id)sender;





- (void)editContent:(Content *)content;
- (void)newContent;

@end
