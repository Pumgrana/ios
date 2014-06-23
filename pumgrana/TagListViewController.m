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

- (void)viewWillAppear:(BOOL)animated
{
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
    for (Tag *t in self.selectedTags) {
        if ([t isEqualToTag:tag]) {
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
    
    for (Tag *t in self.selectedTags) {
        if ([t isEqualToTag:tag]) {
            [self.selectedTags removeObject:t];
            alreadyExists = YES;
            cell.imageView.image = [UIImage imageNamed:@"border.png"];
            break ;
        }
    }
    
    if (!alreadyExists) {
        [self.selectedTags addObject:tag];
        cell.imageView.image = [UIImage imageNamed:@"tick-and-border.png"];
    }
}





- (void)loadDataWithTags:(NSMutableArray *)tags selectedTags:(NSMutableArray *)selectedTags
{
    self.tags = tags;
    self.selectedTags = selectedTags;
}

@end
