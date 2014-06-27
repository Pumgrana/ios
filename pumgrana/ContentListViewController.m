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
#import "PartialContentProtocol.h"

@interface ContentListViewController ()

@end

@implementation ContentListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.content = nil;
        self.contentsToShow = [[NSMutableArray alloc] init];
        self.allTags = [[NSMutableArray alloc] init];
        self.filteredTags = [[NSMutableArray alloc] init];
        
        self.contentEditView = nil;
        self.contentView = nil;
        self.tagListView = nil;
        
        self.addContentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddContentPush:)];
    }
    
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.contentEditView == nil)
        self.contentEditView = [[ContentEditViewController alloc] initWithNibName:@"ContentEditViewController" bundle:[NSBundle mainBundle]];
    
    if (self.contentView == nil)
        self.contentView = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:[NSBundle mainBundle]];
    
    if (self.tagListView == nil)
        self.tagListView = [[TagListViewController alloc] initWithNibName:@"TagListViewController" bundle:[NSBundle mainBundle]];
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
    
    id<PartialContentProtocol> content = [self.contentsToShow objectAtIndex:indexPath.row];
    cell.textLabel.text = [content getContentTitle];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.contentView animated:YES];

    id <PartialContentProtocol> content = [self.contentsToShow objectAtIndex:indexPath.row];
    [self.contentView loadContentWithId:[content getContentId]];
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.content == nil) {
        // Case 1: First view displaying all contents
        
        self.navigationItem.rightBarButtonItem = self.addContentButton;
        
        self.contentsToShow = [ApiManager getContentsFilteredByTags:self.filteredTags];
        self.allTags = [ApiManager getTagsWithType:TAG_TYPE_CONTENT];
    } else {
        // Case 2: Displaying a content's links
        
        self.contentsToShow = [ApiManager getLinksFilteredByTags:self.filteredTags content:self.content];
        self.allTags = [ApiManager getTagsFromContentLinks:self.content];
    }
    
    [self updateTagListLabel];
    
    [self.contentTableView reloadData];
}





/**
 * When pushing the add content button
 */
- (IBAction)buttonAddContentPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.contentEditView animated:YES];
    
    [self.contentEditView newContent];
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
            self.tagListLabel.text = [self.tagListLabel.text stringByAppendingFormat:@"%@", t.subject];
            if (t != [self.filteredTags lastObject])
                self.tagListLabel.text = [self.tagListLabel.text stringByAppendingString:@", "];
        }
    } else {
        self.tagListLabel.text = @"All tags";
    }
}

@end
