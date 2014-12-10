//
//  NetworkController.h
//  MixedUp
//
//  Created by Kori Kolodziejczak on 12/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface NetworkController : NSObject

+(NetworkController*)sharedInstance;

-(void)requestOAuthAccess;
-(void)handleOAuthURL: (NSURL*) callbackURL;

@end
