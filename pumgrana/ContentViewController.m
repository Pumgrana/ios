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
    
    [self.loadingView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadContentWithUri:self.content.uri];
}





- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receivedData = [[NSMutableData alloc] init];
    [self.loadingView setHidden:NO];
    [self.loadingView startAnimating];
    self.title = @"Loading";
    self.titleLabel.text = @"Loading";
    self.summaryLabel.text = @"Loading";
    self.textTextView.text = @"Loading";
    [self.bodyWebView setHidden:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.content = [ApiManager getContentWithUri_Data:self.receivedData];
    self.content.tags = [ApiManager getContentTags:self.content];
    self.content.links = [ApiManager getContentLinks:self.content];
    
    self.title = self.content.title;
    self.titleLabel.text = self.content.title;
    self.summaryLabel.text = self.content.summary;
    self.textTextView.text = self.content.body;
    
    if (self.content.external) {
        [self.textTextView setHidden:YES];
        [self.bodyWebView setHidden:NO];
        
        [self.bodyWebView loadHTMLString:self.content.body baseURL:[[NSBundle mainBundle] resourceURL]];
    } else {
        [self.textTextView setHidden:NO];
        [self.bodyWebView setHidden:YES];
    }
    
    [self.loadingView setHidden:YES];
    [self.loadingView stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail");
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
 * @param uri The uri of the content
 */
- (void)loadContentWithUri:(NSString *)uri
{
    [ApiManager getContentWithUri_Connection:uri delegate:self];
    self.content = [[Content alloc] init];
    self.content.uri = uri;
}

@end
