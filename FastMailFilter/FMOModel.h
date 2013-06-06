//
//  FMOModel.h
//  FastMailFilter
//
//  Created by Moe Burney on 2013-06-03.
//  Copyright (c) 2013 Dev70. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMOModel : NSObject

+(FMOModel *)sharedDataManager;

@property (nonatomic) NSMutableArray *inboxMessages;

@end
