//
//  ContentEditLinksViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 26/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"
#import "ContentEditLinkTagsViewController.h"

@interface ContentEditLinksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

/**
 * Popup to show when an error occurs
 */
@property (nonatomic, strong) UIAlertView *errorAlert;

/**
 * Table to display the contents in
 */
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;





/**
 * View to edit link tags
 */
@property (nonatomic, strong) ContentEditLinkTagsViewController *contentEditLinkTagsView;





/**
 * Content to edit
 */
@property (nonatomic, strong) Content *content;

/**
 * Contents to be displayed
 */
@property (nonatomic, strong) NSMutableArray *contents;





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)rowSwitchChanged:(id)sender;

@end
