//
//  ContentEditLinksViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 26/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentEditLinksViewController.h"
#import "Content.h"
#import "ApiManager.h"
#import "Link.h"

@interface ContentEditLinksViewController ()

@end

@implementation ContentEditLinksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.content = nil;
        self.contents = [[NSMutableArray alloc] init];
        
        self.contentEditLinkTagsView = nil;
        
        self.errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        self.errorAlert.tag = 1;
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Links";
    
    if (self.contentEditLinkTagsView == nil)
        self.contentEditLinkTagsView = [[ContentEditLinkTagsViewController alloc] initWithNibName:@"ContentEditLinkTagsViewController" bundle:[NSBundle mainBundle]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    Content *content = [self.contents objectAtIndex:indexPath.row];
    cell.textLabel.text = content.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchView setOn:NO animated:NO];
    [switchView setTag:indexPath.row];
    [switchView addTarget:self action:@selector(rowSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchView;
    
    for (Link *link in self.content.links) {
        if ([content isEqualToLink:link]) {
            [switchView setOn:YES animated:NO];
            break ;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}





- (void)viewWillAppear:(BOOL)animated
{
    self.contents = [ApiManager getContents];
    
    [self.contentTableView reloadData];
}





/**
 * When pushing a button on the alert popup
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

/**
 * One of the switch in the table has changed
 */
- (void)rowSwitchChanged:(id)sender
{
    UISwitch *switchView = sender;
    Content *content = [self.contents objectAtIndex:switchView.tag];
    
    if (switchView.isOn) {
        if ([self.content isEqualToContent:content]) {
            [switchView setOn:NO animated:NO];
            [self.errorAlert setMessage:@"You can't link to this content as it is the one you are editing"];
            [self.errorAlert show];
        } else {
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
            [nav pushViewController:self.contentEditLinkTagsView animated:YES];
            
            Link *newLink = [[Link alloc] initFromContent:content];
            [self.contentEditLinkTagsView editLink:newLink content:self.content];
        }
    }
    else {
        for (Link *link in self.content.links) {
            if ([content isEqualToLink:link]) {
                [self.content.links removeObject:link];
                break ;
            }
        }
    }
}

@end
