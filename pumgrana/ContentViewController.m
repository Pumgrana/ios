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
        
        self.editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(buttonEditPush:)];
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
        self.navigationItem.rightBarButtonItem = self.editButton;
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





- (IBAction)buttonEditPush:(id)sender;
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.contentEditView animated:YES];
    
    self.contentEditView.title = @"Edit";
    self.contentEditView.content = self.content;
    self.contentEditView.currentTitle = self.content.title;
    self.contentEditView.currentDescription = self.content.text;
    self.contentEditView.allTags = [ApiManager getTags];
    self.contentEditView.filteredTags = [[NSMutableArray alloc] initWithArray:self.content.tags];
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
    self.labelTitle.text = self.content.title;
    self.textViewDescription.text = self.content.text;
}

@end
