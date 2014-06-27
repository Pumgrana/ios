//
//  ContentEditLinkTagsViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 27/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentEditLinkTagsViewController.h"

@interface ContentEditLinkTagsViewController ()

@end

@implementation ContentEditLinkTagsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.link = nil;
        self.content = nil;
        self.tags = [[NSMutableArray alloc] init];
        
        self.errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        self.errorAlert.tag = 1;
        
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDonePush:)];
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
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
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    Tag *tag = [self.tags objectAtIndex:indexPath.row];
    cell.textLabel.text = tag.subject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchView setOn:NO animated:NO];
    [switchView setTag:indexPath.row];
    [switchView addTarget:self action:@selector(rowSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchView;
    
    for (Tag *t in self.link.tags) {
        if ([t isEqualToTag:tag]) {
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
    [super viewWillAppear:animated];
    
    // TODO: load "link" tags via API
    
    [self.tagTableView reloadData];
}





/**
 * When pushing the done button
 */
- (IBAction)buttonDonePush:(id)sender
{
    if ([self.link.tags count] == 0) {
        [self.errorAlert setMessage:@"You must choose at least one tag"];
        [self.errorAlert show];
    } else {
        [self.content.links addObject:self.link];
        
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
        [nav popViewControllerAnimated:YES];
    }
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
    Tag *tag = [self.tags objectAtIndex:switchView.tag];
    
    if (switchView.isOn) {
        [self.link.tags addObject:tag];
    } else {
        for (Tag *t in self.link.tags) {
            if ([t isEqualToTag:tag]) {
                [self.link.tags removeObject:t];
                break ;
            }
        }
    }
}





- (void)editLink:(Link *)link content:(Content *)content
{
    self.link = link;
    self.content = content;
}

@end
