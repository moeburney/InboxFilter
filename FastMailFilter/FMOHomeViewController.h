//
//  FMOHomeViewController.h
//  FastMailFilter
//
//  Created by Moe Burney on 2013-05-23.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMOHomeViewController : UIViewController<UIAlertViewDelegate>

@property NSUInteger totalMessagesToFetch;
@property (weak, nonatomic) IBOutlet UILabel *loadingEmailsLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingEmailsSpinner;

@end
