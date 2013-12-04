//
//  TagListViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 22/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentListViewController.h"

@interface TagListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ContentListViewController *contentListView;
@property (nonatomic, strong) NSMutableArray *tags;

@end
