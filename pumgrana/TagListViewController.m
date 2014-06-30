//
//  TagListViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 22/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import "TagListViewController.h"
#import "Tag.h"
#import "ApiManager.h"

@interface TagListViewController ()

@end

@implementation TagListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tags = [[NSMutableArray alloc] init];
        self.selectedTags = [[NSMutableArray alloc] init];
        self.isDeleting = NO;
        self.selectedTag = nil;
        self.type = TAG_TYPE_CONTENT;
        
        self.editTagView = nil;
        
        self.deleteTagButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(buttonDeleteTagPush:)];
        self.addTagButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddTagPush:)];
        
        self.tagDeleteAlert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
        self.tagDeleteAlert.tag = 1;
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Tags";
    
    if (self.editTagView == nil)
        self.editTagView = [[EditTagViewController alloc] initWithNibName:@"EditTagViewController" bundle:[NSBundle mainBundle]];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.addTagButton, self.deleteTagButton, nil];
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
        
        for (Tag *t in self.selectedTags) {
            if ([t isEqualToTag:tag]) {
                [switchView setOn:YES];
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
    self.isDeleting = YES;
    [self toggleDeleteMode];
    [self.tagListTable reloadData];
}





/**
 * When pushing delete tag button
 */
- (IBAction)buttonDeleteTagPush:(id)sender
{
    [self toggleDeleteMode];
}

/**
 * When pushing add tag button
 */
- (IBAction)buttonAddTagPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.editTagView animated:YES];
    
    [self.editTagView addTagWithType:self.type tags:self.tags selectedTags:self.selectedTags];
}

/**
 * When pushing the red trash of a tag row to delete it
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
 * When pushing a button a the delete tag alert
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
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
            
            for (Tag *t in self.selectedTags) {
                if ([t isEqualToTag:self.selectedTag]) {
                    [self.selectedTags removeObject:t];
                    break ;
                }
            }
            
            [self.tagListTable reloadData];
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
    
    if (switchView.isOn)
        [self.selectedTags addObject:tag];
    else {
        for (Tag *t in self.selectedTags) {
            if ([t isEqualToTag:tag]) {
                [self.selectedTags removeObject:t];
                break ;
            }
        }
    }
}





/**
 * Loading tags to manage
 */
- (void)loadDataWithTags:(NSMutableArray *)tags selectedTags:(NSMutableArray *)selectedTags type:(NSString *)type
{
    self.tags = tags;
    self.selectedTags = selectedTags;
    self.type = type;
}

/**
 * Switch mode between deleting or not
 */
- (void)toggleDeleteMode
{
    if (self.isDeleting) {
        self.deleteTagButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(buttonDeleteTagPush:)];
        self.isDeleting = NO;
    } else {
        self.deleteTagButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonDeleteTagPush:)];
        self.isDeleting = YES;
    }
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.addTagButton, self.deleteTagButton, nil];
    [self.tagListTable reloadData];
}

@end
