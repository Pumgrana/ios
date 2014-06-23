//
//  ContentListViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 13/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import "ContentListViewController.h"
#import "Content.h"
#import "Tag.h"
#import "TagListViewController.h"
#import "ApiManager.h"

@interface ContentListViewController ()

@end

@implementation ContentListViewController
@synthesize contentTableView;
@synthesize filteredTags;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.content = nil;
        self.contentsToShow = [[NSMutableArray alloc] init];
        self.allTags = [[NSMutableArray alloc] init];
        self.filteredTags = [[NSMutableArray alloc] init];
        
        self.contentView = nil;
        self.tagListView = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Lower views creation
    if (self.contentView == nil) {
        ContentViewController *viewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:[NSBundle mainBundle]];
        self.contentView = viewController;
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentsToShow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    Content *content = [self.contentsToShow objectAtIndex:indexPath.row];
    cell.textLabel.text = content.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.contentView animated:YES];

    Content *content = [self.contentsToShow objectAtIndex:indexPath.row];

    self.contentView.title = content.title;
    self.contentView.content = content;
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableArray *allContents;
    
    if (self.content == nil) {
        self.allTags = [ApiManager getTags];
        allContents = [ApiManager getContents];
        
        for (Content *content in allContents) {
            [ApiManager getContentLinks:content contents:allContents];
            content.tags = [ApiManager getContentTags:content];
        }
    } else {
        self.allTags = [ApiManager getTags]; // TO CHANGE
        allContents = self.content.links;
    }

    [self updateTagListLabel];
    [self manageContentsToShowWithContents:allContents];
    
    [self.contentTableView reloadData];
}





/**
 * When pushing the tags button.
 */
- (IBAction)buttonTagPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.tagListView animated:YES];
     
    [self.tagListView loadDataWithTags:self.allTags selectedTags:self.filteredTags];
}





/*
 * Updates the label based on filtered tags
 */
- (void)updateTagListLabel
{
    if ([self.filteredTags count] > 0) {
        self.tagListLabel.text = @"Allowed tags: ";
        for (Tag *t in self.filteredTags) {
            self.tagListLabel.text = [self.tagListLabel.text stringByAppendingFormat:@"%@", t.label];
            if (t != [self.filteredTags lastObject])
                self.tagListLabel.text = [self.tagListLabel.text stringByAppendingString:@", "];
        }
    } else {
        self.tagListLabel.text = @"All tags";
    }
}

/*
 * Decides which contents to actually display based on filtered tags
 */
- (void)manageContentsToShowWithContents:(NSMutableArray *)contents
{
    self.contentsToShow = [[NSMutableArray alloc] init];
    
    if ([self.filteredTags count] > 0) {
        for (Content *ctt in contents) {
            for (Tag *t in self.filteredTags) {
                if ([ctt hasTag:t]) {
                    [self.contentsToShow addObject:ctt];
                    break ;
                }
            }
        }
    } else {
        for (Content *ctt in contents)
            [self.contentsToShow addObject:ctt];
    }
}

@end
