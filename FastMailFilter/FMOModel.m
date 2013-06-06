//
//  FMOModel.m
//  FastMailFilter
//
//  Created by Moe Burney on 2013-06-03.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import "FMOModel.h"

@implementation FMOModel

- (id)init
{
    self = [super init];
    self.inboxMessages = [[NSMutableArray alloc] init];    
    return self;
}

+(FMOModel *)sharedDataManager
{
	static dispatch_once_t onceToken = 0;
	static FMOModel *dataManager = nil;
	dispatch_once(&onceToken, ^{
		dataManager = [[FMOModel alloc] init];
	});
	return dataManager;
}

@end
