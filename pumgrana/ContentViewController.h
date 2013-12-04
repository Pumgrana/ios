//
//  ContentViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 13/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTagListViewController.h"

@class ContentListViewController;

@interface ContentViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

@property (nonatomic, strong) ContentListViewController *contentListView;
@property (nonatomic, strong) ContentTagListViewController *contentTagListView;

@property (nonatomic, strong) Content *content;

- (IBAction)buttonTagsPush:(id)sender;
- (IBAction)buttonLinksPush:(id)sender;

@end
