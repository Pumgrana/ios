//
//  EditTagViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 30/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "ApiManager.h"

@interface EditTagViewController : UIViewController <UIAlertViewDelegate>

/**
 * Popup displayed when the tag has been added
 */
@property (nonatomic, strong) UIAlertView *doneAlert;

/**
 * Button "done" in navigation bar
 */
@property (nonatomic, retain) UIBarButtonItem *doneButton;

/**
 * Input field for tag subject
 */
@property (weak, nonatomic) IBOutlet UITextField *subjectField;





/**
 * Tag to edit
 */
@property (nonatomic, strong) Tag *temporaryTag;

/**
 * Type of tag to insert
 */
@property (nonatomic, strong) NSString *type;

/**
 * All tags
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 * Tags selected
 */
@property (nonatomic, strong) NSMutableArray *selectedTags;





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)buttonDonePush:(id)sender;

- (void)addTagWithType:(NSString *)type tags:(NSMutableArray *)tags selectedTags:(NSMutableArray *)selectedTags;

@end
