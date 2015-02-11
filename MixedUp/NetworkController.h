//
//  NetworkController.h
//  MixedUp
//
//  Created by Kori Kolodziejczak on 12/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Beat.h"

@interface NetworkController : NSObject
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString* user_ID;


+(NetworkController*)sharedInstance;

-(void)requestOAuthAccess;
-(void)handleOAuthURL: (NSURL*) callbackURL;
//<<<<<<< HEAD
//-(void)searchTerm:(NSString *)name completionHandler: (void(^)(NSError *error, NSMutableArray *beats))completionHandler;
//-(void)getMyPlaylists:(NSString *)name completionHandler: (void(^)(NSError *error, NSMutableArray *playlists))completionHandler;
//=======
-(void)federatedSearchTerm:(NSString *)name completionHandler: (void(^)(NSError *error, NSDictionary *beats))completionHandler;
-(void)moreSearchTerm:(NSString *)name type:(NSString *)type completionHandler: (void(^)(NSError *error, NSDictionary *beats))completionHandler;
-(void)getMyPlaylists:(NSString *)name completionHandler: (void(^)(NSError *error, NSDictionary *playlists))completionHandler;
-(void)getMyUserID: (void(^)(NSError *error, NSString *userID))completionHandler;

@end
