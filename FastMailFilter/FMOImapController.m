//
//  FMOImapController.m
//  FastMailFilter
//
//  Created by Moe Burney on 2013-05-23.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import "FMOImapController.h"
#import "FMOEmailMessage.h"
#import "FMOModel.h"
#import <MailCore/MailCore.h>

@implementation FMOImapController

- (id)init
{
    self = [super init];
    
    self.inboxMessages = [[NSMutableArray alloc] init];
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.account = [[CTCoreAccount alloc] init];
     
    return self;
}

- (void)connectToImapServer:(void (^)(NSUInteger a))success
                    failure:(void (^)(NSError *error))failure
{

    __weak FMOImapController *weakSelf = self;
    
    dispatch_queue_t bgQueue = dispatch_queue_create("FMO", NULL);
    
    dispatch_async(bgQueue, ^{
        BOOL successConnectedToServer = [weakSelf.account connectToServer:@"imap.gmail.com"
                                                                     port:993
                                                           connectionType:CONNECTION_TYPE_TLS
                                                                 authType:IMAP_AUTH_TYPE_PLAIN
                                                                    login:@""
                                                                 password:@""];
        
        if (successConnectedToServer)
        {
            weakSelf.inbox = [weakSelf.account folderWithPath:@"INBOX"];
            success(0);
        }
        else
        {
            failure(weakSelf.account.lastError);
        }
        
    });
    

}

+(FMOImapController *)sharedDataManager
{
	static dispatch_once_t onceToken = 0;
	static FMOImapController *dataManager = nil;
	dispatch_once(&onceToken, ^{
		dataManager = [[FMOImapController alloc] init];
	});
	return dataManager;
}

-(void)getInboxMessageCount:(void (^)(NSUInteger messageCount))success
                    failure:(void (^)(NSError *error))failure
{
    __block BOOL successGotInbox = NO;
    
    CTCoreFolder *inbox = [self.account folderWithPath:@"INBOX"];
    dispatch_queue_t bgQueue = dispatch_queue_create("FMO1", NULL);
    
    dispatch_async(bgQueue, ^{
        NSUInteger totalMessagesInbox;
        successGotInbox = [inbox totalMessageCount:&totalMessagesInbox];
        (successGotInbox)?success(totalMessagesInbox):failure(inbox.lastError);
    });
}

//This method is currently not working. For now use
//getAllInboxMessagesWithCompletion which fetches
//all the messages at once
-(void)getInboxMessages:(NSInteger)numberOfMessages
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure
{

    //Use thread safe NSOperation queue to fetch messages
    
    __weak FMOImapController *weakSelf = self;

    for (int i = 1; i < numberOfMessages; i++)
    {
        [self.operationQueue addOperationWithBlock:^{
            if ([[weakSelf.inbox messagesFromSequenceNumber:i to:(i+1) withFetchAttributes:CTFetchAttrEnvelope] objectAtIndex:0] != nil)
            {
                NSLog(@"not nil");
                FMOModel *dataManager = [FMOModel sharedDataManager];
                [dataManager.inboxMessages addObject:[[weakSelf.inbox messagesFromSequenceNumber:i to:(i+1) withFetchAttributes:CTFetchAttrEnvelope] objectAtIndex:0]];
            }
            else
            {
                NSLog(@"nil");
            }
        }];
    }
    success();
}

-(void)getAllInboxMessagesWithCompletion:(void (^)(void))success
                                 failure:(void (^)(NSError *error))failure
{
    __weak FMOImapController *weakSelf = self;
    
    dispatch_queue_t bgQueue = dispatch_queue_create("FMO2", NULL);
    dispatch_async(bgQueue, ^{
        [FMOModel sharedDataManager].inboxMessages = [[weakSelf.inbox messagesFromSequenceNumber:1 to:0 withFetchAttributes:CTFetchAttrEnvelope] mutableCopy];
        if ([FMOModel sharedDataManager].inboxMessages != nil)
        {
            success();
        }
        else
        {
            failure([weakSelf.inbox lastError]);
        }
    });
}


@end
