//
//  FMOEmailMessage.h
//  FastMailFilter
//
//  Created by Moe Burney on 2013-05-24.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMOEmailMessage : NSObject

@property (nonatomic) NSInteger messageID;
@property (nonatomic) NSUInteger messageUID;
@property (nonatomic) NSUInteger sequenceNumber;
@property (nonatomic) NSString *body;
@property (nonatomic) NSString *from;
@property (nonatomic) NSString *subject;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *senderEmailAddress;
@property (nonatomic) NSString *senderName;

@end
