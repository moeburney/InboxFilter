//
//  FMOHomeViewController.m
//  FastMailFilter
//
//  Created by Moe Burney on 2013-05-23.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import "FMOHomeViewController.h"
#import "FMOImapController.h"
#import "UIAlertView+Blocks.h"
#import "FMOMailViewController.h"


@interface FMOHomeViewController ()

@end

@implementation FMOHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//First try to connect to the IMAP server 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadingEmailsLabel.hidden = YES;
    self.loadingEmailsSpinner.hidden = YES;

    __weak FMOHomeViewController *weakSelf = self;
    
    FMOImapController *dataManager = [FMOImapController sharedDataManager];
    [dataManager connectToImapServer:^(NSUInteger a) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Succesfully connected to server, we can move forward
            [weakSelf showNumberOfEmailsAlert];
        });}
         failure:^(NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"%@", error);});}];

}

//Fetch number of emails from server
//and give user choice to view them or cancel
-(void)showNumberOfEmailsAlert
{
    __weak FMOHomeViewController *weakSelf = self;

    [[FMOImapController sharedDataManager] getInboxMessageCount:
     ^(NSUInteger totalMessageCount){
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"%lu", (unsigned long)totalMessageCount);
             weakSelf.totalMessagesToFetch = totalMessageCount;
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
                                                             message:[NSString stringWithFormat:@"You have %lu unfiltered emails in your inbox. View and filter them now?", (unsigned long)self.totalMessagesToFetch]
                                                            delegate:weakSelf
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"View",nil];
             [alert show];
         });
        }
              failure:^(NSError *error) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      NSLog(@"%@", error);
                  });
              }];

}

//If user chooses to view emails, fetch all emails
//then show navigation view controller with the email content
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak FMOHomeViewController *weakSelf = self;

    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"View"])
    {
        self.loadingEmailsLabel.hidden = NO;
        self.loadingEmailsSpinner.hidden = NO;
        [self.loadingEmailsSpinner startAnimating];


        [[FMOImapController sharedDataManager] getAllInboxMessagesWithCompletion:^(void){
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                FMOMailViewController *mailController = [[FMOMailViewController alloc] init];
                                                                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mailController];
                                                                mailController.counter = 0;
                                                                [weakSelf presentViewController:navController animated:YES completion:nil];
                                                            });
                                                        }
                                                        failure:^(NSError *error) {
                                                            NSLog(@"error");
                                                        }];
    }
    else if([title isEqualToString:@"Cancel"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Cancelled");
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoadingEmailsLabel:nil];
    [self setLoadingEmailsSpinner:nil];
    [super viewDidUnload];
}
@end
