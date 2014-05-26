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
@synthesize contentListView;
@synthesize tags;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.contentListView)
        self.usedView = self.contentListView;
    else
        self.usedView = self.contentEditView;
    
    [self.tagListTable reloadData];
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
    cell.textLabel.text = tag.label;
    
    BOOL alreadyExists = NO;
    for (Tag *t in self.usedView.filteredTags) {
        if ([t.label isEqualToString:tag.label]) {
            alreadyExists = YES;
            cell.imageView.image = [UIImage imageNamed:@"tick-and-border.png"];
            break ;
        }
    }
    if (!alreadyExists)
        cell.imageView.image = [UIImage imageNamed:@"border.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Tag *tag = [self.tags objectAtIndex:indexPath.row];
    BOOL alreadyExists = NO;
    
    for (Tag *t in self.usedView.filteredTags) {
        if ([t.label isEqualToString:tag.label]) {
            [self.usedView.filteredTags removeObject:t];
            alreadyExists = YES;
            cell.imageView.image = [UIImage imageNamed:@"border.png"];
            break ;
        }
    }
    
    if (!alreadyExists) {
        [self.usedView.filteredTags addObject:tag];
        cell.imageView.image = [UIImage imageNamed:@"tick-and-border.png"];
    }
}

@end
