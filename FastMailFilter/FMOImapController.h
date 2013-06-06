//
//  FMOImapController.h
//  FastMailFilter
//
//  Created by Moe Burney on 2013-05-23.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

@interface FMOImapController : NSObject

+(FMOImapController *)sharedDataManager;

- (void)connectToImapServer:(void (^)(NSUInteger a))success
                    failure:(void (^)(NSError *error))failure;

-(void)getInboxMessageCount:(void (^)(NSUInteger messageCount))success
                    failure:(void (^)(NSError *error))failure;

-(void)getInboxMessages:(NSInteger)numberOfMessages
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;

-(void)getAllInboxMessagesWithCompletion:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;


@property (nonatomic) CTCoreAccount *account;
@property (nonatomic) CTCoreFolder *inbox;

@property (nonatomic) NSMutableArray *inboxMessages;
@property NSOperationQueue *operationQueue;


@end
