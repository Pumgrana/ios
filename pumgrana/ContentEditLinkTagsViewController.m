//
//  ContentEditLinkTagsViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 27/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentEditLinkTagsViewController.h"
#import "ApiManager.h"

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
        self.isDeleting = NO;
        self.selectedTag = nil;
        
        self.editTagView = nil;
        
        self.errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        self.errorAlert.tag = 1;
        
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDonePush:)];
        
        self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonActionPush:)];
        
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add tag", @"Delete tag", nil];
        self.actionSheet.tag = 1;
        
        self.tagDeleteAlert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
        self.tagDeleteAlert.tag = 2;
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.editTagView == nil)
        self.editTagView = [[EditTagViewController alloc] initWithNibName:@"EditTagViewController" bundle:[NSBundle mainBundle]];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.doneButton, self.actionButton, nil];
    
    self.title = @"Tags";
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
    
    if (self.isDeleting) {
        UIButton *buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImage *image = [UIImage imageNamed:@"red-trash-40x40.png"];
        [buttonView setImage:image forState:UIControlStateNormal];
        [buttonView setTag:indexPath.row];
        [buttonView addTarget:self action:@selector(buttonTagRowDeletePush:) forControlEvents:UIControlEventTouchDown];
        cell.accessoryView = buttonView;
    } else {
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
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tags = [ApiManager getTagsWithType:TAG_TYPE_LINK];
    
    [self.tagTableView reloadData];
}





/**
 * When pushing a delete button on a row
 */
- (IBAction)buttonTagRowDeletePush:(id)sender
{
    UIButton *button = sender;
    Tag *tag = [self.tags objectAtIndex:button.tag];
    
    self.selectedTag = tag;
    
    [self.tagDeleteAlert setMessage:[[NSString alloc] initWithFormat:@"Are you sure you want to delete the tag \"%@\"?", tag.subject]];
    [self.tagDeleteAlert show];
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
 * When pushing the action button
 */
- (IBAction)buttonActionPush:(id)sender
{
    [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

/**
 * When pushing a button on the action sheet
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        // Actions "popup"
        
        if (buttonIndex == 0) {
            // Add tag
            
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
            [nav pushViewController:self.editTagView animated:YES];
            
            [self.editTagView addTagWithType:TAG_TYPE_LINK tags:self.tags selectedTags:self.link.tags];
        } else if (buttonIndex == 1) {
            // Delete tag or Cancel deleting
            
            if (self.isDeleting) {
                self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add tag", @"Delete tag", nil];
                self.isDeleting = NO;
            } else {
                self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add tag", @"Cancel deleting mode", nil];
                self.isDeleting = YES;
            }
            
            self.actionSheet.tag = 1;
            [self.tagTableView reloadData];
        }
    }
}

/**
 * When pushing a button on the alert popup
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        // Delete tag alert
        
        if (buttonIndex == 0) {
            // Yes
            
            [ApiManager deleteTags:[[NSMutableArray alloc] initWithObjects:self.selectedTag, nil]];
            
            for (Tag *t in self.tags) {
                if ([t isEqualToTag:self.selectedTag]) {
                    [self.tags removeObject:t];
                    break ;
                }
            }
            
            for (Tag *t in self.link.tags) {
                if ([t isEqualToTag:self.selectedTag]) {
                    [self.link.tags removeObject:t];
                    break ;
                }
            }
            
            [self.tagTableView reloadData];
        } else {
            // No
        }
        
        self.selectedTag = nil;
    }
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





/**
 * Loads view data
 */
- (void)editLink:(Link *)link content:(Content *)content
{
    self.link = link;
    self.content = content;
    self.isDeleting = NO;
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add tag", @"Delete tag", nil];
    self.actionSheet.tag = 1;
    
    [self.tagTableView reloadData];
}

@end
