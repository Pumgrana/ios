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
#import "ContentEditLinksViewController.h"

@interface ContentEditViewController ()

@end

@implementation ContentEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.temporaryContent = nil;
        self.savedLinks = nil;
        
        self.tagListView = nil;
        self.contentEditLinksView = nil;
        
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
    
    if (self.contentEditLinksView == nil)
        self.contentEditLinksView = [[ContentEditLinksViewController alloc] initWithNibName:@"ContentEditLinksViewController" bundle:[NSBundle mainBundle]];
    
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
    
    self.allTags = [ApiManager getTagsWithType:TAG_TYPE_CONTENT];
    
    if (self.temporaryContent.uri == nil) {
        // Creating a new content instead of editing
        
        self.title = @"New";
    }
    
    self.titleField.text = self.temporaryContent.title;
    self.summaryField.text = self.temporaryContent.summary;
    self.textField.text = self.temporaryContent.body;
    
    if (self.temporaryContent.external) {
        [self.textField setHidden:YES];
        self.titleField.enabled = NO;
        self.summaryField.enabled = NO;
    } else {
        [self.textField setHidden:NO];
        self.titleField.enabled = YES;
        self.summaryField.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.temporaryContent.title = self.titleField.text;
    self.temporaryContent.summary = self.summaryField.text;
    self.temporaryContent.body = self.textField.text;
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
 * When pushing the done button
 */
- (IBAction)buttonDonePush:(id)sender;
{
    self.temporaryContent.title = self.titleField.text;
    self.temporaryContent.summary = self.summaryField.text;
    self.temporaryContent.body = self.textField.text;
    
    NSString *msg;
    if (self.temporaryContent.uri == nil) {
        // Creating
        
        NSString *uri = [ApiManager insertContent:self.temporaryContent];
        self.temporaryContent.uri = uri;
        
        for (Link *link in self.temporaryContent.links)
            [ApiManager insertLink:link content:self.temporaryContent];
        
        msg = [[NSString alloc] initWithFormat:@"Content \"%@\" successfully created!", self.temporaryContent.title];
    } else {
        // Editing
        
        if (self.temporaryContent.external) {
            [ApiManager updateContentTags:self.temporaryContent];
        } else {
            [ApiManager updateContent:self.temporaryContent];
        }
        
        for (Link *link in self.temporaryContent.links) {
            BOOL found = NO;
            
            for (Link *savedLink in self.savedLinks) {
                if ([savedLink.contentUri isEqualToString:link.contentUri] && [link.tags count] > 0) {
                    // Link has been modified
                    
                    [ApiManager deleteLinks:[[NSMutableArray alloc] initWithObjects:savedLink, nil]];
                    [ApiManager insertLink:link content:self.temporaryContent];
                    found = YES;
                }
            }
            
            if (!found) {
                // Link has been created
                
                [ApiManager insertLink:link content:self.temporaryContent];
            }
        }
        
        for (Link *savedLink in self.savedLinks) {
            BOOL found = NO;
            
            for (Link *link in self.temporaryContent.links) {
                if ([savedLink.contentUri isEqualToString:link.contentUri])
                    found = YES;
            }
            
            if (!found) {
                // Link has been deleted
                
                [ApiManager deleteLinks:[[NSMutableArray alloc] initWithObjects:savedLink, nil]];
            }
        }
        
        msg = [[NSString alloc] initWithFormat:@"Content \"%@\" successfully edited!", self.temporaryContent.title];
    }
    
    [self.editAlert setMessage:msg];
    [self.editAlert show];
}

/**
 * When the tags button is pushed
 */
- (IBAction)buttonTagsPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.tagListView animated:YES];
    
    [self.tagListView loadDataWithTags:self.allTags selectedTags:self.temporaryContent.tags type:TAG_TYPE_CONTENT];
}

/**
 * When the links button is pushed
 */
- (IBAction)buttonLinksPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.contentEditLinksView animated:YES];
    
    self.contentEditLinksView.content = self.temporaryContent;
}





/**
 * Loads a content to edit
 * @param content The content to edit
 */
- (void)editContent:(Content *)content
{
    self.temporaryContent = [[Content alloc] initFromContent:content];
    self.savedLinks = [[NSMutableArray alloc] initWithArray:self.temporaryContent.links];
}

/**
 * Prepare the view for a new content
 */
- (void)newContent
{
    self.temporaryContent = [[Content alloc] init];
    
    self.titleField.text = @"";
    self.summaryField.text = @"";
    self.textField.text = @"";
}

@end
