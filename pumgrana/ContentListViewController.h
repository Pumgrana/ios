//
//  ContentListViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 13/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "AppDelegate.h"
#import "TagListViewController.h"

@class TagListViewController;

@interface ContentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tagList;
@property (nonatomic, strong) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, strong) NSMutableArray *contentsToShow;
@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *filteredTags;

@property (nonatomic, strong) ContentViewController *contentView;
@property (nonatomic, strong) TagListViewController *tagListView;

- (IBAction)buttonTagPush:(id)sender;

@end
