//
//  MainViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 22/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "ContentListViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    
    nav.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonSystemItemAction target:self action:@selector(buttonHomePush)];
    
    NSMutableArray *viewStack = [NSMutableArray arrayWithArray:[nav viewControllers]];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    ContentListViewController *contentListView = [sb instantiateViewControllerWithIdentifier:@"ContentListViewController"];
    [viewStack replaceObjectAtIndex:0 withObject:contentListView];
    
    [nav setViewControllers:viewStack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonHomePush {
    NSLog(@"Home");
}

- (IBAction)buttonHomePush:(id)sender {
    NSLog(@"Home");
}

@end
