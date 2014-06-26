//
//  TagListViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 22/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import "TagListViewController.h"
#import "Tag.h"

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
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}





- (void)viewWillAppear:(BOOL)animated
{
    [self.tagListTable reloadData];
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





- (void)loadDataWithTags:(NSMutableArray *)tags selectedTags:(NSMutableArray *)selectedTags
{
    self.tags = tags;
    self.selectedTags = selectedTags;
}

@end
