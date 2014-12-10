//
//  NetworkController.h
//  MixedBeats
//
//  Created by Brian Mendez on 12/9/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

-(void)searchTerm:(NSString *)name completionHandler: (void(^)(NSError *error, NSMutableArray *beats))completionHandler;

+(NetworkController *)sharedManager;

@end