//
//  FMOMailViewController1.h
//  FastMailFilter
//
//  Created by Moe Burney on 2013-05-24.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMOMailViewController : UIViewController
- (IBAction)clickedNext:(id)sender;
- (IBAction)clickedPrev:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyView;

@property (nonatomic) NSString *str1;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) int counter;


@end
