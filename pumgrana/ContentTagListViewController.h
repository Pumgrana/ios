//
//  ContentTagListViewController.h
//  pumgrana
//
//  Created by Romain Pichot on 18/11/2013.
//  Copyright (c) 2013 Romain Pichot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"

@interface ContentTagListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Content *content;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;

@end
