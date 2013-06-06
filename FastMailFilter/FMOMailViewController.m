//
//  FMOMailViewController1.m
//  FastMailFilter
//
//  Created by Moe Burney on 2013-05-24.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import "FMOMailViewController.h"
#import "FMOImapController.h"
#import "NSTimer+Blocks.h"
#import "FMOModel.h"
#import <QuartzCore/QuartzCore.h>

@interface FMOMailViewController ()

@end

@implementation FMOMailViewController

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
    
    self.navigationController.navigationBarHidden = YES;
    UISwipeGestureRecognizer *rightSwipeRecognizer;
    UISwipeGestureRecognizer *leftSwipeRecognizer;

    
    rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [rightSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    
    leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [leftSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftSwipeRecognizer];
            
    self.subjectLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:21.0f];
    self.fromLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
    self.bodyView.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0f];


    
    [self populateContent];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateContent
{
    __weak FMOMailViewController *weakSelf = self;
    FMOModel *dataManager = [FMOModel sharedDataManager];
    
    if ([[dataManager.inboxMessages objectAtIndex:weakSelf.counter] subject] != nil)
    {
        weakSelf.subjectLabel.text = [[dataManager.inboxMessages objectAtIndex:weakSelf.counter] subject];
    }
    
    
    if ([[dataManager.inboxMessages objectAtIndex:weakSelf.counter] body] != nil)
    {
        weakSelf.bodyView.text = [[dataManager.inboxMessages objectAtIndex:self.counter] body];
    }
     
    
    /*
    if ([[dataManager.inboxMessages objectAtIndex:weakSelf.counter] date] != nil)
    {
        //self.dateLabel.text = [[dataManager.inboxMessages weakSelf] date];
    }
     */

    
    if ([[dataManager.inboxMessages objectAtIndex:weakSelf.counter] sender] != nil)
    {
        weakSelf.fromLabel.text = [[[[dataManager.inboxMessages objectAtIndex:weakSelf.counter] from] allObjects] componentsJoinedByString:@" "];
        weakSelf.fromLabel.text = [@"From " stringByAppendingString:weakSelf.fromLabel.text];
    }

}

//Display the next Email
- (IBAction)clickedNext:(id)sender
{
    
    __weak FMOMailViewController *weakSelf = self;
    

    //Use the same cuurent view controller class but instantiate a new object
    //with a new email.
    FMOMailViewController *nextController = [[FMOMailViewController alloc] init];
    nextController.counter = self.counter + 1;
    
    //Wait until event loop is cleared before pushing next email.
    dispatch_async(dispatch_get_main_queue(), ^{
        CATransition *transition = [CATransition animation];
        transition.duration = 0.65;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        
        // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        [weakSelf.navigationController setViewControllers:@[nextController] animated:NO];
    });
}

- (IBAction)clickedPrev:(id)sender
{
    __weak FMOMailViewController *weakSelf = self;
    
    if (self.counter > 0)
    {
        //Use the same cuurent view controller class but instantiate a new object
        //with a new email.
        FMOMailViewController *prevController = [[FMOMailViewController alloc] init];
        prevController.counter = self.counter - 1;
        
        //Wait until event loop is cleared before pushing next email.
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.65;
            transition.timingFunction =
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            
            // NSLog(@"%s: controller.view.window=%@", _func_, controller.view.window);
            UIView *containerView = self.view.window;
            [containerView.layer addAnimation:transition forKey:nil];
            [weakSelf.navigationController setViewControllers:@[prevController] animated:NO];
        });
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self clickedNext:nil];
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        [self clickedPrev:nil];
    }
}

- (void)viewDidUnload {
    [self setBodyView:nil];
    [super viewDidUnload];
}
@end
