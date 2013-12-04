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

@interface ContentListViewController ()

@end

@implementation ContentListViewController
@synthesize contentTableView;
@synthesize filteredTags;

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
    
    if (self.contentView == nil) {
        ContentViewController *viewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:[NSBundle mainBundle]];
        self.contentView = viewController;
    }
    if (self.tagListView == nil) {
        TagListViewController *viewController = [[TagListViewController alloc] initWithNibName:@"TagListViewController" bundle:[NSBundle mainBundle]];
        self.tagListView = viewController;
    }
    
    self.filteredTags = [[NSMutableArray alloc] init];
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
    
    if (self.contents == nil) {
        Tag *tag1 = [[Tag alloc] initWithLabel:@"Tag test 1"];
        Tag *tag2 = [[Tag alloc] initWithLabel:@"Tag test 2"];
        Content *content1 = [[Content alloc] initWithTitle:@"Content 1" description:@"This is the first content." tags:[[NSMutableArray alloc] initWithObjects:tag1, nil] links:[[NSMutableArray alloc] initWithObjects:nil]];
        Content *content2 = [[Content alloc] initWithTitle:@"Content 2" description:@"This is the second content." tags:[[NSMutableArray alloc] initWithObjects:tag2, nil] links:[[NSMutableArray alloc] initWithObjects:content1, nil]];
    
        self.contents = [[NSMutableArray alloc] initWithObjects:content1, content2, nil];
    }
  
    // **
    // Making an array of every tag
    // **
    self.allTags = [[NSMutableArray alloc] init];
    
    for (Content *c in self.contents) {
        for (Tag *contentTag in c.tags) {
            BOOL tagAlreadyExists = NO;
            
            for (Tag *t in self.allTags) {
                if (contentTag.label == t.label) {
                    tagAlreadyExists = YES;
                    break ;
                }
            }
            
            if (!tagAlreadyExists) {
                [self.allTags addObject:contentTag];
                break ;
            }
        }
    }

    
    // **
    // Making an array of displayed contents based on filtered tags
    // **
    self.contentsToShow = [[NSMutableArray alloc] init];
    
    if ([self.filteredTags count] > 0) {
        for (Content *ctt in self.contents) {
            for (Tag *t in self.filteredTags) {
                if ([ctt hasTag:t.label]) {
                    [self.contentsToShow addObject:ctt];
                    break ;
                }
            }
        }
    } else {
        for (Content *ctt in self.contents)
            [self.contentsToShow addObject:ctt];
    }

    if ([self.filteredTags count] > 0) {
        self.tagList.text = @"Allowed tags: ";
        for (Tag *t in self.filteredTags) {
            self.tagList.text = [self.tagList.text stringByAppendingFormat:@"%@", t.label];
            if (t != [self.filteredTags lastObject])
                self.tagList.text = [self.tagList.text stringByAppendingString:@", "];
        }
    } else {
        self.tagList.text = @"All tags";
    }
    
    [self.contentTableView reloadData];
}

- (IBAction)buttonTagPush:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
    [nav pushViewController:self.tagListView animated:YES];
    
    self.tagListView.title = @"Tags";
    self.tagListView.contentListView = self;
    self.tagListView.tags = self.allTags;
}

@end
