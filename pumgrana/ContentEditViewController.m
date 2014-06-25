//
//  ContentEditViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 07/04/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ContentEditViewController.h"
#import "ApiManager.h"

@interface ContentEditViewController ()

@end

@implementation ContentEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.temporaryContent = nil;
        
        self.tagListView = nil;
        
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDonePush:)];
        
        self.editAlert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        self.editAlert.tag = 1;
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.navigationItem.rightBarButtonItem == nil)
        self.navigationItem.rightBarButtonItem = self.doneButton;
    
    [[self.textField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.textField layer] setBorderWidth:0.6];
    [[self.textField layer] setCornerRadius:5];
    
    if (self.tagListView == nil)
        self.tagListView = [[TagListViewController alloc] initWithNibName:@"TagListViewController" bundle:[NSBundle mainBundle]];
    
    self.title = @"Edit";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.allTags = [ApiManager getTags];
    
    self.titleField.text = self.temporaryContent.title;
    self.summaryField.text = self.temporaryContent.summary;
    self.textField.text = self.temporaryContent.text;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.temporaryContent.title = self.titleField.text;
    self.temporaryContent.summary = self.summaryField.text;
    self.temporaryContent.text = self.textField.text;
}





/**
 * When pushing a button on the alert popup
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
            
            [nav popViewControllerAnimated:YES];
        }
    }
}





/**
 * When pushing the send button.
 */
- (IBAction)buttonDonePush:(id)sender;
{
    self.temporaryContent.title = self.titleField.text;
    self.temporaryContent.summary = self.summaryField.text;
    self.temporaryContent.text = self.textField.text;
    
    [ApiManager updateContent:self.temporaryContent];
    
    [self.editAlert setMessage:[[NSString alloc] initWithFormat:@"Content \"%@\" successfully edited!", self.temporaryContent.title]];
    [self.editAlert show];
}

/**
 * When the tags button is pushed.
 */
- (IBAction)buttonTagsPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.tagListView animated:YES];
    
    [self.tagListView loadDataWithTags:self.allTags selectedTags:self.temporaryContent.tags];
}





/**
 * Loads the content to edit, fills the textfields
 * @param content The content to edit
 */
- (void)loadContent:(Content *)content
{
    self.temporaryContent = [[Content alloc] initFromContent:content];
}

@end
