//
//  EditTagViewController.m
//  pumgrana
//
//  Created by Romain Pichot on 30/06/2014.
//  Copyright (c) 2014 Romain Pichot. All rights reserved.
//

#import "AppDelegate.h"
#import "EditTagViewController.h"

@interface EditTagViewController ()

@end

@implementation EditTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.temporaryTag = nil;
        self.type = TAG_TYPE_CONTENT;
        self.tags = [[NSMutableArray alloc] init];
        self.selectedTags = [[NSMutableArray alloc] init];
        
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDonePush:)];
        
        self.doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        self.doneAlert.tag = 1;
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.subjectField.text = self.temporaryTag.subject;
}





/**
 * When pushing a button in the alert view
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        // Done
        
        if (buttonIndex == 0) {
            // Ok
            
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)(del.window.rootViewController);
            [nav popViewControllerAnimated:YES];
        }
    }
}

/**
 * When pushing done button
 */
- (IBAction)buttonDonePush:(id)sender
{
    self.temporaryTag.subject = self.subjectField.text;
    
    self.temporaryTag.uri = [ApiManager insertTag:self.temporaryTag type:self.type];
    
    [self.tags addObject:self.temporaryTag];
    [self.selectedTags addObject:self.temporaryTag];
    
    [self.doneAlert setMessage:[[NSString alloc] initWithFormat:@"Tag \"%@\" successfully added!", self.temporaryTag.subject]];
    [self.doneAlert show];
}





/**
 * Adding a new tag
 */
- (void)addTagWithType:(NSString *)type tags:(NSMutableArray *)tags selectedTags:(NSMutableArray *)selectedTags
{
    self.temporaryTag = [[Tag alloc] init];
    
    self.temporaryTag.subject = @"";
    
    self.type = type;
    self.tags = tags;
    self.selectedTags = selectedTags;
}

@end
