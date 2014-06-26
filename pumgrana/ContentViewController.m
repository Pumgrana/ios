//
//  ContentViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 13/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "ContentListViewController.h"
#import "ApiManager.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.content = nil;
        
        self.contentEditView = nil;
        self.contentTagListView = nil;
        self.contentListView = nil;
        
        self.moreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonMorePush:)];
        
        
        self.moreActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", @"Delete", nil];
        self.moreActionSheet.tag = 1;
        
        self.deleteAlert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Yes", @"No", nil];
        self.deleteAlert.tag = 1;
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.contentEditView == nil)
        self.contentEditView = [[ContentEditViewController alloc] initWithNibName:@"ContentEditViewController" bundle:[NSBundle mainBundle]];
    
    if (self.contentTagListView == nil)
        self.contentTagListView = [[ContentTagListViewController alloc] initWithNibName:@"ContentTagListViewController" bundle:[NSBundle mainBundle]];
    
    if (self.contentListView == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        self.contentListView = [sb instantiateViewControllerWithIdentifier:@"ContentListViewController"];
    }
    
    if (self.navigationItem.rightBarButtonItem == nil)
        self.navigationItem.rightBarButtonItem = self.moreButton;
    
    self.textTextView.editable = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadContentWithId:self.content.id];
}





/**
 * When pushing a button on the action sheet
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
        
        if (buttonIndex == 0) {
            // Edit content
            
            [nav pushViewController:self.contentEditView animated:YES];
            [self.contentEditView editContent:self.content];
        } else if (buttonIndex == 1) {
            // Delete content
            
            [self.deleteAlert setMessage:[[NSString alloc] initWithFormat:@"Are you sure you want to delete the content \"%@\" ?", self.content.title]];
            [self.deleteAlert show];
            
        }
    }
}

/**
 * When pushing a button on the alert popup
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            // Yes
            
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
            
            [nav popViewControllerAnimated:YES];
            [ApiManager deleteContents:[[NSMutableArray alloc] initWithObjects:self.content, nil]];
        } else if (buttonIndex == 1) {
            // No
        }
    }
}





- (IBAction)buttonMorePush:(id)sender;
{
    [self.moreActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)buttonTagsPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.contentTagListView animated:YES];
    
    self.contentTagListView.content = self.content;
}

- (IBAction)buttonLinksPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.contentListView animated:YES];
    
    self.contentListView.title = @"Links";
    self.contentListView.content = self.content;
}




/**
 * Loads a new content in the view
 * @param id The id of the content
 */
- (void)loadContentWithId:(NSString *)id
{
    self.content = [ApiManager getContentWithId:id];
    self.content.tags = [ApiManager getContentTags:self.content];
    self.content.links = [ApiManager getContentLinks:self.content];
    
    self.title = self.content.title;
    self.titleLabel.text = self.content.title;
    self.summaryLabel.text = self.content.summary;
    self.textTextView.text = self.content.text;
}

@end
