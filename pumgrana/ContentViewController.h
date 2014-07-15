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

@interface ContentViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>

/**
 * "More" button in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *moreButton;

/**
 * "More" action sheet (popup with different actions)
 */
@property (nonatomic, strong) UIActionSheet *moreActionSheet;

/**
 * Popup displayed on delete action
 */
@property (nonatomic, strong) UIAlertView *deleteAlert;

/**
 * Label containing the title of the content.
 */
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

/**
 * Label containing the summary of the content
 */
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

/**
 * Text area containing the description of the content.
 */
@property (weak, nonatomic) IBOutlet UITextView *textTextView;

/**
 * Webview to display if it is an external content
 */
@property (weak, nonatomic) IBOutlet UIWebView *bodyWebView;




/**
 * The view to be used to edit the content.
 */
@property (nonatomic, strong) ContentEditViewController *contentEditView;

/**
 * The view to be used to display the tags of the content.
 */
@property (nonatomic, strong) ContentTagListViewController *contentTagListView;

/**
 * The view to be used to display the links of the content.
 */
@property (nonatomic, strong) ContentListViewController *contentListView;





/**
 * The content to display.
 */
@property (nonatomic, strong) Content *content;





/**
 * When pushing the more button.
 */
- (IBAction)buttonMorePush:(id)sender;

/**
 * When pushing the tags button.
 */
- (IBAction)buttonTagsPush:(id)sender;

/**
 * When pushing the links button.
 */
- (IBAction)buttonLinksPush:(id)sender;





- (void)loadContentWithUri:(NSString *)uri;

@end
