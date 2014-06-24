//
//  ContentEditViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 07/04/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

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
        self.sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(buttonSendPush:)];
        self.currentTitle = [[NSString alloc] init];
        self.currentDescription = [[NSString alloc] init];
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.tagListView == nil) {
        TagListViewController *viewController = [[TagListViewController alloc] initWithNibName:@"TagListViewController" bundle:[NSBundle mainBundle]];
        self.tagListView = viewController;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = self.sendButton;
    self.titleField.text = self.currentTitle;
    self.contentField.text = self.currentDescription;
}





- (IBAction)buttonSendPush:(id)sender;
{
    self.content.title = [[NSString alloc] initWithString:self.titleField.text];
    self.content.text = [[NSString alloc] initWithString:self.contentField.text];
    self.content.tags = [[NSMutableArray alloc] initWithArray:self.filteredTags];
    
    [ApiManager updateContent:self.content];
}

- (IBAction)buttonTagsPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.tagListView animated:YES];
    
    self.currentTitle = [[NSString alloc] initWithString:self.titleField.text];
    self.currentDescription = [[NSString alloc] initWithString:self.contentField.text];
     
    [self.tagListView loadDataWithTags:self.allTags selectedTags:self.filteredTags];
}

@end
